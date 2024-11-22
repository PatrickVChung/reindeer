class PermissionGroup < ActiveRecord::Base
  has_many :users, inverse_of: :permission_group
  has_many :permission_ls_groups,
    inverse_of: :permission_group,
    dependent: :destroy,
    after_add: :dirty_user_ls_lists

  has_many :role_aggregates, through: :lime_surveys

  accepts_nested_attributes_for :permission_ls_groups, allow_destroy: true,
    reject_if: :all_blank
  validates_associated :permission_ls_groups
  validates :title, presence: true, uniqueness: true


  def dirty_user_ls_lists plsg
    users.each {|u| u.dirty_ls_list }
  end


  ##
  # Calculate the role_aggregate that this user can see
  def role_aggregates_for user
    details, result = explain_role_aggregates_for user
    return result
  end

  ##
  # TODO: Move to helper
  def explain_role_aggregates_for user
    details = []
    result = role_aggregates.select{|ra|
      ready = ra.ready_for_use?
      details.push([ra, 'RA not ready for use']) unless ready
      ready
    }
    return details, result
  end
end 
