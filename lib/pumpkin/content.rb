class Pumpkin::Content
  include MongoMapper::Document
  plugin MongoMapper::Plugins::IdentityMap
  PATH_SEPARATOR = ':'

  key :node_id,   String,  :required => true, :index => true
  key :depth,     Integer, :default => 0,  :index => true
  key :path,      String,  :default => "", :index => true
  key :parent_id, ObjectId
  timestamps!
  
  #Callbacks
  before_create :set_path, :set_depth
  
  #Relationships
  belongs_to :parent, :class_name => 'Pumpkin::Content'
  
  #Validations
  validates_format_of     :node_id, :with => /\A\w[\w\.+\-_@ ]+$/
  validates_uniqueness_of :node_id, :scope => :parent_id, :case_sensitive => false  
  
  def self.root
    where(:depth => 0).limit(1).first
  end
  
  def root?
    self.depth.zero?
  end

  def descendant_of?(node)
    self.path.start_with?(node.path)
  end
  
  # all children
  def descendants
    self.class.all(:path => descendants_regexp, :order => 'path')
  end
  
  private
  def set_path
    if self.parent_id
      self.path = "#{self.parent.path}#{PATH_SEPARATOR}#{self.node_id.downcase}"
    else
      self.path = "#{self.node_id.downcase}"
    end
  end
  
  def set_depth
    self.depth = self.path.count(PATH_SEPARATOR)
  end
  
  def parent_path
    self.path.split(PATH_SEPARATOR)[0...-1].join(PATH_SEPARATOR)
  end
  
  def descendants_regexp
    /#{self.path}#{PATH_SEPARATOR}.*/
  end
end