class DataPoint
  include Mongoid::Document
  include Mongoid::Timestamps
  field :submitted_at, type: Time
  field :started_at, type: Time
  field :ended_at, type: Time
  field :details
  scope :recent, desc(:started_at).limit(10)

  after_save :flush_cache

  def flush_cache
    Rails.cache.delete([self.class.name, "recent"])
  end

  def self.cached_recent
    Rails.cache.fetch [name, "recent"] do
      recent.to_a
    end
  end

  def self.find args
    if args.to_i.to_s == args
      args = args.to_i
      return self.order_by(:created_at.asc)[args]
    else
      super(args)
    end
  end

  def self.zorg_it(opts={})
    data = Hash.new
    data[:key] = Figaro.env.RESCUETIME_TOKEN
    data[:format] = 'json'
    # data[:operation] = 'select'
    # data[:version] = '0'
    end_string = Time.now.strftime "%Y-%m-%d"
    start_string = 1.day.ago.strftime "%Y-%m-%d"
    data.merge!( {
      perspective: "interval",
      resolution_time: "hour",
      restrict_begin: end_string,
      restrict_end: end_string
    })
    data.merge! opts
    p "Calling rescuetime with:", data
    url = "https://www.rescuetime.com/anapi/data"
    json = Hashie::Mash.new JSON.parse(RestClient.post url, data)
  end
  def self.examine hashie
    zug = hashie.rows.map do |activity|
      pick = activity.values_at 0, 1, 3
      pick[1] = Time.at(pick[1]).utc.strftime "%Mm %Ss"
      pick
    end
    pp zug
  end
  def self.import_from_rescue_time hashie

  end
  def self.instantiate_from_rescuetime_hour

  end
end
