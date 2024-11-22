class PermissionLsGroup < ActiveRecord::Base

  belongs_to :permission_group, inverse_of: :permission_ls_groups

  has_one :role_aggregate, through: :lime_survey
  has_many :permission_ls_group_filters, dependent: :destroy,
   inverse_of: :permission_ls_group

  validates_presence_of :role_aggregate

  validate :validate_enabled_allowed

  accepts_nested_attributes_for :permission_ls_group_filters, allow_destroy: true

  def validate_enabled_allowed
    if enabled && !enabled_allowed?
      if !role_aggregate.present?
        # Must explicitly allow view_all, or have filters
        errors.add(:enabled, 'No role_aggregate defined')
      elsif !role_aggregate.ready_for_use?
        errors.add(:enabled, 'Role aggregate configuration is not complete')
      else
        # Must explicitly allow view_all, or have filters
        errors.add(:enabled, 'requires "view all" or enabled filters')
      end
    end
  end

  def enabled_allowed?
    return role_aggregate.present? && role_aggregate.ready_for_use? && (
      view_all == true || permission_ls_group_filters.select{|plgf| plgf.enabled? }.count > 0
    )
  end

  
end
