require 'spec_helper'

describe ItemShare do
  pending "add some examples to (or delete) #{__FILE__}"
end



# == Schema Information
#
# Table name: item_shares
#
#  id          :integer         not null, primary key
#  item_id     :integer
#  item_type   :string(255)
#  group_id    :integer
#  creator_id  :integer
#  admins_only :boolean         default(FALSE), not null
#  created_at  :datetime
#  updated_at  :datetime
#

