#by using the symbol ':user', we can get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Ryland Herrick"
  user.email                 "ryalnd@gmail.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@ry-land.com"
end
