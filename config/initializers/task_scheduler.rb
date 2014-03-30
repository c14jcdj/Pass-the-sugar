scheduler = Rufus::Scheduler.new

###################################################
#Chron schedile syntax

#MIN HOUR DOM MON DOW CMD

# Field	Description	  Allowed Value
# MIN	  Minute field	0 to 59
# HOUR	Hour field	  0 to 23
# DOM	  Day of Month	1-31
# MON 	Month field	  1-12
# DOW	  Day Of Week	  0-6
# CMD	  Command	Any   command to be executed.
###################################################

#send one out every day at noon
scheduler.cron("0 12 * * *") do
  Diabetic.all.each do |diabetic|
  	DiabeticMailer.reminder_email(diabetic).deliver
 	end
end 

scheduler.cron("* 7 * * 0") do
  Diabetic.all.each do |diabetic|
  	unless (diabetic.records.length == 0) || (diabetic.doctor == nil)
      data = diabetic.get_data_for_pdf
      pdf = RecordDataPdf.new(data, diabetic)
  		DoctorMailer.attachment_email(diabetic, pdf).deliver
  	end
 	end
end 


# for a certain frequency, something like
# scheduler.every("1m") do
#   Diabetic.all.each do |diabetic|
#   	#DiabeticMailer.reminder_email(diabetic).deliver
#  	end
# end 