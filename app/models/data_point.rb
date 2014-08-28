class DataPoint
  include Mongoid::Document
  include Mongoid::Timestamps
  field :submitted_at, type: Time
  field :at, type: Time
  field :ended_at, type: Time
  field :details
  field :type

  ##
  # Returns the underlying type (a string)
  # e.g., "DataPoint", "LastFmDp"
  #
  def type
    _type rescue nil
  end


  scope :recent, -> { desc(:at).limit(10) }
  default_scope -> { desc(:at) }

  after_save :flush_cache
  before_save :set_at

  def set_at
    self.at = Time.zone.now unless self.at
  end

  def flush_cache
    Rails.cache.delete([self.class.name, "recent"])
  end

  def self.cached_recent
    Rails.cache.fetch ["DataPoint", "recent"] do
      recent.to_a
    end
  end

  ##
  # Over ridden find method that accepts an integer argument, returns
  # the ith DataPoint
  def self.find args
    if args.to_i.to_s == args
      args = args.to_i
      return self.order_by(:created_at.asc)[args]
    else
      super(args)
    end
  end

  def self.latest
    desc(:at).first
  end

  def to_msg
    details.to_yaml.gsub(/\n/, "; ")
  rescue
    "(none)"
  end
end
