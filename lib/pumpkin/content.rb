class Pumpkin::Content
  include MongoMapper::Document
  plugin MongoMapper::Plugins::IdentityMap
  plugin Joint
  PATH_SEPARATOR = ':'

  key :node_id,   String,  :required => true, :index => true
  key :depth,     Integer, :default => 0,  :index => true
  key :path,      String,  :default => "", :index => true
  key :parent_id, ObjectId
  timestamps!
  
  #Callbacks
  before_create :set_path
  after_save    :save_attachments
  #after_save     :destroy_nil_attachments
  #before_destroy :destroy_all_attachments
  
  #Relationships
  belongs_to :parent, :class_name => 'Pumpkin::Content'
  
  #Validations
  validates_format_of     :node_id, :with => /\A\w[\w\.+\-_@ ]+$/
  validates_uniqueness_of :node_id, :scope => :parent_id, :case_sensitive => false
  
  def self.root
    where(:depth => 0).limit(1).first
  end
  
  def self.find_by_path(path)
    path = Array(path) unless path.is_a?(Array)
    where(:path => /#{path.join(PATH_SEPARATOR)}/i).limit(1).first
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
  
  def attributes=(attrs)
    return if attrs.blank?

    attrs.each_pair do |key, value|
      if respond_to?(:"#{key}=")
        self.send(:"#{key}=", value)
      elsif value.respond_to?(:read)
        self["#{key}_id"]   = BSON::ObjectId.new
        self["#{key}_name"] = Joint.name(value)
        self["#{key}_size"] = Joint.size(value)
        self["#{key}_type"] = Joint.type(value)        
        define_attachment_proxy(key)
        assigned_attachments[:"#{key}"] = value
        #nil_attachments.delete(:"#{key}")
      else
        self[key] = value
      end
    end
  end
  
  private
  def set_path
    if self.parent_id
      self.path = "#{self.parent.path}#{PATH_SEPARATOR}#{self.node_id.downcase}"
    else
      self.path = "#{self.node_id.downcase}"
    end
    self.depth = self.path.count(PATH_SEPARATOR)
  end
  
  def parent_path
    self.path.split(PATH_SEPARATOR)[0...-1].join(PATH_SEPARATOR)
  end
  
  def descendants_regexp
    /#{self.path}#{PATH_SEPARATOR}.*/
  end
  
  def load_from_database(attrs)
    super
    rs = key_names.map { |k| k.split("_") }
    rs = rs.group_by { |i| i[0] } 
    rs = rs.keys.select! { |k| rs[k].size == 4 && (rs[k] - [[k,"id"],[k,"size"],[k,"name"],[k,"type"]]).empty? }
    rs.each { |m| define_attachment_proxy(m) }
  end
  
  def define_attachment_proxy(name)
    unless respond_to?(:"#{name}")
      instance_eval <<-EOC
        def #{name}; @#{name} ||= Joint::AttachmentProxy.new(self, :#{name}); end
      EOC
    end
  end
end