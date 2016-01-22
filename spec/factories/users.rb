FactoryGirl.define do
  factory :user_en, class: User do
    username "User EN"
    email "user_en@example.com"
    password "please123"
    confirmed_at Time.now
    language "en"
  end
  
  factory :user_de, class: User do
    username "User DE"
    email "user_de@example.com"
    password "please123"
    confirmed_at Time.now
    language "de"
  end
end
