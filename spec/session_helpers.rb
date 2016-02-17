module Features
  module SessionHelpers
    def sign_up_with(email, password, confirmation, language="en")
      visit root_path
      fill_in 'signup_user_email', with: email
      fill_in 'signup_user_password', with: password
      fill_in 'signup_user_password_confirmation', :with => confirmation
      # select language, :from => 'signup_user_language'
      click_button 'sign_up'
    end

    def signin(email, password)
      visit root_path
      fill_in 'login_user_email', with: email
      fill_in 'login_user_password', with: password
      click_button 'login'
    end
  end
end
