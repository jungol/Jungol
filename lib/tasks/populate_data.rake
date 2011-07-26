namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    require 'populator'

    Rake::Task['db:reset'].invoke

    #    User.populate 20 do |user|
    #      user.name     = Faker::Name.name
    #      user.email    = Faker::Internet.email
    #      user.about    = Populator.words(10..15).titleize
    #      user.encrypted_password = Populator.words(1)
    #    # user.password_confirmation = user.encrypted_password
    #     # user.skip_confirmation!
    #    end

    #Create users, groups, and items
    30.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@jungolhq.com"
      password = "foobar"
      user = User.new :name => name,
        :email => email,
        :about => Populator.words(10..15),
        :password => password,
        :password_confirmation => password

      user.skip_confirmation!
      user.save!
      if(n % 2 == 0)  #Create new group every other time
        group = user.created_groups.create :name => "Group #{n}",
          :about => Populator.words(10..30)

        group.users << User.find(n-1) unless n.zero?
        disc = user.created_discussions.create :title => "Discussion ##{n}",
          :description => Populator.words(10..30)
        group.discussions << disc

        todo = user.created_todos.create :title => "Todo ##{n}", :description => Populator.words(10..20)
        group.todos << todo
        Random.rand(10).times do
          todo.tasks.create :description => Populator.words(1..3)
        end

      end
    end

    15.times do |n|   ## make 20 random group connections
      group = Group.find(n+1)
      random_group = Group.find(Random.rand(15) +1)
      group.groups << random_group
      random_group.groups << group

      #share items between groups: discussion from group A and todo from group B

      new_share = group.creator.created_shares.create
      disc = group.discussions.first
      disc.item_shares << new_share
      random_group.item_shares << new_share

      new_share2 = random_group.creator.created_shares.create
      todo = random_group.todos.first
      todo.item_shares << new_share2
      group.item_shares << new_share2
    end
  end
end
