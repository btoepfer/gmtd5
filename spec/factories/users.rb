FactoryGirl.define do
  factory :user do
    username "Test User"
    email "test@example.com"
    password "please123"
    confirmed_at Time.now
    language "en"
  end
  

end
