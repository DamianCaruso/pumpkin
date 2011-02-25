class Pumpkin::Content
  include MongoMapper::Document
  include MongoMapper::Acts::Tree
  plugin MongoMapper::Plugins::IdentityMap

  key :node_id, String, :required => true, :index => true
  timestamps!

  acts_as_tree :order => "node_id asc"
  
  validates_uniqueness_of :node_id, :scope => :parent_id

  #mount_uploader :photo, CarrierWave::Uploader::Base
end