class Document < ActiveRecord::Base
  attr_accessible :title, :description, :doc

  belongs_to :group
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  has_many :item_shares, :dependent => :destroy, :as => :item, :order => 'created_at ASC'
  has_many :shared_groups, :through => :item_shares, :source => :group
  has_many :comments, :dependent => :destroy, :as => :item, :order => 'created_at ASC'
  has_many :interactions, :dependent => :destroy, :as => :item
  has_many :interactors, :through => :interactions, :source => :user, :uniq => true

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
    :content_type => %w(image/jpg
                        image/jpeg
                        image/pjpeg
                        image/png
                        image/x-png
                        image/gif
                        application/pdf
                        application/msword
                        application/vnd.openxmlformats-officedocument.wordprocessingml.document
                        application/vnd.openxmlformats-officedocument.wordprocessingml.template
                        application/vnd.ms-word.document.macroEnabled.12
                        application/vnd.ms-word.template.macroEnabled.12 application/vnd.ms-excel
                        application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
                        application/vnd.openxmlformats-officedocument.spreadsheetml.template
                        application/vnd.ms-excel.sheet.macroEnabled.12
                        application/vnd.ms-excel.template.macroEnabled.12
                        application/vnd.ms-excel.addin.macroEnabled.12
                        application/vnd.ms-excel.sheet.binary.macroEnabled.12
                        application/vnd.ms-powerpoint
                        application/vnd.openxmlformats-officedocument.presentationml.presentation
                        application/vnd.openxmlformats-officedocument.presentationml.template
                        application/vnd.openxmlformats-officedocument.presentationml.slideshow
                        application/vnd.ms-powerpoint.addin.macroEnabled.12
                        application/vnd.ms-powerpoint.presentation.macroEnabled.12
                        application/vnd.ms-powerpoint.template.macroEnabled.12
                        application/vnd.ms-powerpoint.slideshow.macroEnabled.12),
    :message => 'is not allowed (only images, .pdfs, and MS Office filetypes)'
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

