class ConsumerRolePolicy < ApplicationPolicy
  def privacy?
    if @user.has_role? :consumer or
      @user.has_role? :broker or
      @user.has_role? :assister or
      @user.has_role? :csr
      true
    elsif @user.has_role? :employer_staff or
      @user.has_role? :employee #or
      #@user.has_role? :broker_agency_staff or
      #@user.has_role? :resident or
      #@user.has_role? :hbx_staff or
      #@user.has_role? :system_service or
      #@user.has_role? :web_service
      false
    elsif @user.roles.blank?
      true
    end
  end

  def search?
    privacy?
  end

  def match?
    privacy?
  end

  def create?
    privacy?
  end

  def ridp_agreement?
    privacy?
  end

  def edit?
    if @user.has_role? :hbx_staff
      true
    elsif @user.has_role? :consumer
      @user.person.consumer_role.id == @record.id
    else
      false
    end
  end

  def update?
    edit?
  end
end
