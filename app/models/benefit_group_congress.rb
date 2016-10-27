class BenefitGroupCongress < BenefitGroup

  field :contribution_pct_as_int, type: Integer, default: 75
  field :employee_max_amt_in_cents, type: Money, default: 0
  field :first_dependent_max_amt_in_cents, type: Integer, default: 0
  field :over_one_dependents_max_amt_in_cents, type: Integer, default: 0

  field :effective_on_kind, type: String, default: "first_of_month"
  field :plan_option_kind, type: String, default: "metal_level"
  field :default, type: Boolean, default: true

  def set_bounding_cost_plans
    plans = Plan.shop_health_by_active_year(reference_plan.active_year).by_health_metal_levels([reference_plan.metal_level])
    if plans.size > 0
      plans_by_cost = plans.sort_by { |plan| plan.premium_tables.first.cost }

      self.lowest_cost_plan_id  = plans_by_cost.first.id
      @lowest_cost_plan = plans_by_cost.first

      self.highest_cost_plan_id = plans_by_cost.last.id
      @highest_cost_plan = plans_by_cost.last
    end
  end

  def decorated_plan(plan, member_provider, max_contribution_cache = {})
    PlanCostDecoratorCongress.new(plan, member_provider, self, max_contribution_cache)
  end

  def first_dependent_max_amt_in_cents=(new_first_dependent_max_amt_in_cents)
    write_attribute(:first_dependent_max_amt_in_cents, dollars_to_cents(new_first_dependent_max_amt_in_cents))
  end

  def over_one_dependents_max_amt_in_cents=(new_over_one_dependents_max_amt_in_cents)
    write_attribute(:over_one_dependents_max_amt_in_cents, dollars_to_cents(new_over_one_dependents_max_amt_in_cents))
  end

  # TODO may need to write custom self.find

  def employee_cost_for_plan(ce, plan = reference_plan)
    pcd = decorated_plan(plan, ce)
    pcd.total_employee_cost
  end


  # field :reference_plan_id - set to a gold plan so it is gold
  # Congressional model
  # 2014
  # employer pays zero


  # 2015
  # In 2015, Congress Pays 75% of total premium up to the dollar maximum listed below
  # only employee enrolled - employer pays 75% up to max
  # employee + 1 dependent - employer pays 75% up to max - ($900-ish) - ability to set max figure
  # employee > 1 dependent - employer pays 75% of total premium - ability to set max figure

  employer_contribution_max_2015 = {
    "employee_only"       => 437.69,
    "employee_plus_one"   => 971.90,
    "employee_plus_many"  => 971.90
  }

  # In 2016, Congress Pays 75% of total premium up to the dollar maximum listed below
  # EE only: 462.30
  # EE +1 family member: 998.88
  # EE +2 or more family members: 1058.42

  employer_contribution_max_2016 = {
    "employee_only"       => 462.30,
    "employee_plus_one"   => 998.88,
    "employee_plus_many"  => 1058.42
  }


end
