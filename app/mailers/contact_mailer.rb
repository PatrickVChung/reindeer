class ContactMailer < ApplicationMailer


  def contact_form(from_user, to_coordinator, subject, body)
    mail(
      to: to_coordinator,
      from: from_user,
      subject: subject,
      body: body,
      content_type: 'text/html'
    )
  end

end
