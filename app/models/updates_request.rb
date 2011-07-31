class UpdatesRequest < ActiveRecord::Base


  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence => true,
                    :format => {:with => email_regex },
                    :uniqueness => { :case_sensitive => false }
end

# == Schema Information
#
# Table name: updates_requests
#
#  id         :integer         not null, primary key
#  email      :string(255)
#  ip         :string(255)
#  created_at :datetime
#  updated_at :datetime
#

