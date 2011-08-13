namespace :db do
  desc "Approve pending memberships and group connections"
  task :approve_pending => :environment do
    Membership.update_all(:is_pending => false)
    GroupConnection.update_all(:status => 2)
    puts "Pending memberships and connections approved."
  end
end
