ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :my_datetime_format  => '%d.%m.%Y (%H:%M)'
)
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
  :my_date_format  => '%d.%m.%Y'
)
# Email settings
ActionMailer::Base.default_content_type = "text/html"
ActionMailer::Base.delivery_method = :sendmail

ActionMailer::Base.smtp_settings = {
	:tls => true,
  :address => "mail.jbsol.com",
  :port => 465,
  :domain => "mail.jbsol.com",
  :authentication => :login,
  :user_name => "no-reply@jbsol.com",
  :password => "hNLHzDU2"
}


#FastGettext.add_text_domain 'yavlena', :path => File.join(RAILS_ROOT, 'locale') #:path => 'locale'
#FastGettext.text_domain = 'yavlena'

#$imoti_net_last_successful_export = ''
#if !System.inet_last_success.first.nil?
#  $imoti_net_last_successful_export = System.inet_last_success.first.value
#end