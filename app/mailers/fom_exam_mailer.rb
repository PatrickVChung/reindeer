class FomExamMailer < ApplicationMailer
  def alert_student (from_user, to_user, subject, body)
      mail(
        to: to_user,
        from: from_user,
        subject: subject,
        body: body,
        content_type: 'text/html'
      )

  end
end
