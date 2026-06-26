class FomExamMailer < ApplicationMailer
  def send_alert (from_user, to_user, subject, body)
      @body_msg = body

      mail(
        to: to_user,
        from: from_user,
        subject: subject,
        content_type: 'text/html'
      )

  end
end
