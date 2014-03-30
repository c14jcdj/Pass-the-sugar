class DoctorMailer < ActionMailer::Base
  default from: "glucoseamigo@gmail.com"

  def welcome_email(doctor)
    @doctor = doctor
    mail(to: @doctor.email, 
    		 subject: 'Welcome to GlucoseAmigo',
    	   template_path: 'doctor_mailer',
         template_name: 'welcome')
  end


  def attachment_email(diabetic, pdf)
    @diabetic = diabetic
    @doctor = @diabetic.doctor
    attachments["#{@diabetic.name}_#{Time.now.strftime("%Y-%m-%d")}"] = { mime_type: 'application/pdf', content: pdf.render() }
    mail(to: @doctor.email, 
         subject: "#{diabetic.name}'s Report from GlucoseAmigo",
         template_path: 'doctor_mailer',
         template_name: 'report')
  end

end