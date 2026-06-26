class FomExamMailer < ApplicationMailer
  def alert_student (from_user, to_user, subject, body)
<<<<<<< HEAD
=======
      @body_msg = body
>>>>>>> redei-portal_v6
      mail(
        to: to_user,
        from: from_user,
        subject: subject,
<<<<<<< HEAD
        body: body,
=======
>>>>>>> redei-portal_v6
        content_type: 'text/html'
      )

  end
end
