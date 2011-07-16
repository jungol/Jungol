Factory.sequence :name do |n|
  "Group #{n}"
end

Factory.define :group do |group|
  group.name    "Test Group"
  group.about   "About us"
  group.association :creator, :factory => :user
end
