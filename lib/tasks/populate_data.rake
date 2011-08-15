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

    puts "Populating Data..."
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
        user.share group, disc

        todo = user.created_todos.create :title => "Todo ##{n}", :description => Populator.words(10..20)
        group.todos << todo
        user.share group, todo

        Random.rand(10).times do
          todo.tasks.create :description => Populator.words(1..3)
        end

      end
    end

    15.times do |n|   ## make 20 random group connections
      group = Group.find(n+1)
      random_group = Group.find(Random.rand(15) +1)
      if group.connect(random_group)
        #share items between groups: discussion from group A and todo from group B

        disc = group.discussions.first
        group.creator.share random_group, disc

        todo = random_group.todos.first
        random_group.creator.share group, todo
      end

    end

    #FILTERING SHARE
    group = Group.find(7)
    random = Group.find(1)
    disc = group.discussions.first
    group.creator.share random, disc

    todo = random.todos.first
    random.creator.share group, todo

    Rake::Task['db:approve_pending'].invoke
  end
end
