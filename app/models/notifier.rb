class Notifier < ActionMailer::Base
	helper :application
  
  default_url_options[:host] = "shoeaquarium.com"

  def password_reset_instructions(user)
    subject       "Инструкции за смяна на забравена парола"
    from          "ShoeAquarium ERP <erp@shoeaquarium.com>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
  
	
	#handle_asynchronously :deliver_send_bulletin
	
end
