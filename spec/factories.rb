FactoryGirl.define do
  factory :user do
    name      "Casey Driscoll"
    email     "caseypatrickdriscoll@me.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end
