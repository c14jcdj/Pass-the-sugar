ActionMailer::Base.default_url_options[:host] = "localhost:3000"

if Rails.env != 'test'
  if File.exists? ("#{Rails.root}/config/email.yml")
    email_settings = YAML::load(File.open("#{Rails.root.to_s}/config/email.yml"))
    ActionMailer::Base.smtp_settings = email_settings[Rails.env] unless email_settings[Rails.env].nil?

  else
    puts '*' * 50
    puts "Nonfatal error: please include a 'email.yml' file in your config directory and restart your rails sever."
    puts '*' * 50
  end
end