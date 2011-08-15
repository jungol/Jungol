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

  validates_attachment_presence :doc, :message => "must be present. You need to upload a file."
  validates_attachment_size :doc, :less_than => 4.megabyte, :message => "must be less than 4MB in size"
  validates_attachment_content_type :doc,
    :content_type => /^(image\/(jpg|jpeg|pjpeg|png|x-png|gif))|(application\/(pdf|msword|vnd\.(ms\-(excel|powerpoint)|openxmlformats\-officedocument\.(wordprocessingml\.document|spreadsheetml\.sheet|presentationml\.(presentation|slideshow)))))$/,
    :message => 'is not allowed (only images, .pdfs, and MS Office filetypes)'
end
