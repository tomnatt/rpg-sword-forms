FactoryBot.define do
  factory :user do
    name { 'Bob' }
    email { 'foo@example.com' }
    password { 'foobar' }
  end
end
