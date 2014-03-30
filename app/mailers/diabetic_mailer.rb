class DiabeticMailer < ActionMailer::Base
  default from: "glucoseamigo@gmail.com"

  def welcome_email(diabetic)
    #@url  = 'http://example.com/login'
    mail(to: diabetic.email,
    		 subject: 'Welcome to GlucoseAmigo',
    	   template_path: 'diabetic_mailer',
         template_name: 'welcome')
  end

  def reminder_email(diabetic)
    mail(to: diabetic.email,
    		subject: 'Friendly Reminder from GlucoseAmigo',
    	  template_path: 'diabetic_mailer',
        template_name: 'reminder')
  end

end
