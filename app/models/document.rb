class Document < ActiveRecord::Base
  attr_accessible :title, :description, :doc

  belongs_to :group
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  has_many :item_shares, :dependent => :destroy, :as => :item, :order => 'created_at ASC'
  has_many :shared_groups, :through => :item_shares, :source => :group
  has_many :comments, :dependent => :destroy, :as => :item, :order => 'created_at ASC'

  validates( :title, :presence => true,
                      :length => {:maximum => 60},
                      :uniqueness => { :case_sensitive => false})

  validates :description, :presence => true

  has_attached_file :doc, {
    :whiny => false
  }.merge(PAPERCLIP_DOC_OPTIONS)

  validates_attachment_size :doc, :less_than => 2.megabyte, :message => "must be less than 1MB in size"
  validates_attachment_content_type :doc, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'
end
