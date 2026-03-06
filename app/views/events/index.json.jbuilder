# print @events.inspect
# json.set! :data do
#   json.array! @events do |event|
#     json.partial! 'events/event', event: event
#     json.url  "
#               #{link_to 'Show', event }
#               #{link_to 'Edit', edit_event_path(event)}
#               #{link_to 'Destroy', event, method: :delete, data: { confirm: 'Are you sure?' }}
#               "
#   end
# end
json.array! @events do |event|
  json.id event.id

  # Logic to add name to title if user exists
  display_title = event.title
  if event.user_id.present?
    user = User.find_by(id: event.user_id)
    display_title += " - #{user.full_name}" if user
  end

  json.title display_title
  json.description event.description
  json.start event.start_date.iso8601
  json.end event.end_date.iso8601
  json.url event_url(event, format: :html)
end
