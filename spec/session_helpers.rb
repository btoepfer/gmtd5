module Features
  module SessionHelpers
    def sign_up_with(email, password, confirmation, language="en")
      visit new_user_registration_path
      fill_in 'signup_user_mail', with: email
      fill_in 'signup_user_password', with: password
      fill_in 'signup_user_password_confirmation', :with => confirmation
      fill_in 'signup_user_language', :with => language
      click_button 'sign_up'
    end

    def signin(email, password)
      visit new_user_session_path
      fill_in 'login_user_email', with: email
      fill_in 'login_user_password', with: password
      click_button 'login'
    end
  end
end
