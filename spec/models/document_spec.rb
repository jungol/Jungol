require 'spec_helper'

describe Document do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: documents
#
#  id               :integer         not null, primary key
#  creator_id       :integer
#  group_id         :integer
#  title            :string(255)
#  description      :text
#  doc_file_name    :string(255)
#  doc_content_type :string(255)
#  doc_file_size    :integer
#  doc_updated_at   :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

