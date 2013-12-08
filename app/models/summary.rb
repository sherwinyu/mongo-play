class Summary
  include Mongoid::Document
  embedded_in :sp_day

  field :best, type: String
  field :worst, type: String
  field :funny, type: String
  field :insight, type: String
end
