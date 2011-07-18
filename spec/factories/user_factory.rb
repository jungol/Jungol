Factory.sequence :email do |n|
  "person-#{n}@jungolhq.com"
end

Factory.define :user do |user|
  user.sequence(:name)  {|n| "Ryland #{n}. Herrick"}
  user.sequence(:email) {|n| "ryland#{n}@example.com"}
  user.password              "foobar"
  user.password_confirmation "foobar"
end
