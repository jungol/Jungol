namespace :db do
  desc "Fill database with sample data"
  task :approve_memberships => :environment do
    Membership.update_all(:is_pending => false)
  end
end
