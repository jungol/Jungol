Factory.sequence :email do |n|
  "person-#{n}@jungolhq.com"
end

Factory.define :user do |user|
  user.name                  "Ryland Herrick"
  user.sequence(:email) {|n| "ryland#{n}@example.com"}
  user.password              "foobar"
  user.password_confirmation "foobar"
end
