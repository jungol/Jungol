# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'Jungol Admin', :email => 'admin@jungolhq.com', :about => "First user.", :password => 'foobar', :password_confirmation => 'foobar'
user.confirm!
puts 'First user created: ' << user.name

group = user.created_groups.create!(:name => "Jungol", :about => "All about Jungol.")
puts 'First group created: ' << group.name

disc = user.created_discussions.create!(:title => "First Discussion", :description => "This is the first discussion.")
puts 'First Jungol discussion created: ' << disc.title

todo = user.created_todos.create!(:title => "First Todo", :description => "This is the first todo.")
puts 'First Jungol todo created: ' << todo.title

