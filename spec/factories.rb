#by using the symbol ':user', we can get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Ryland Herrick"
  user.email                 "ryland@jungolhq.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :group do |group|
  group.name    "Test Group"
  group.about   "About us"
end

Factory.define :todo do |todo|
  todo.title "Test TODO"
end

Factory.sequence :name do |n|
  "Group #{n}"
end

Factory.sequence :email do |n|
  "person-#{n}@jungolhq.com"
end
