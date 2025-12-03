json.set! :data do
  json.array! @ume_assess_plans do |ume_assess_plan|
    json.partial! 'ume_assess_plans/ume_assess_plan', ume_assess_plan: ume_assess_plan
    json.url  "
              #{link_to 'Show', ume_assess_plan }
              #{link_to 'Edit', edit_ume_assess_plan_path(ume_assess_plan)}
              #{link_to 'Destroy', ume_assess_plan, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end