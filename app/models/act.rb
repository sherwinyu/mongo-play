class Act
  include Mongoid::Document
  include Mongoid::Timestamps

  field :at, type: DateTime
  field :ended_at, type: DateTime
  field :desc, type: String
  belongs_to :day

  validates_presence_of :at
  validates_presence_of :ended_at
  validates_presence_of :desc
  validates_presence_of :day

  scope :recent, -> { desc(:at).limit(10) }

end


=begin
  details:
    field name type string
    embeds_many children_details

details =
  name:

productivity

{ name: all details
  children: [
    { }
    { }
    { }
    { name: productivity, value: 100 }



}

productivity: 100
sleep:
  duration: 8.5
  time_asleep: 3am
  time_awake: 11.5pm
  tiredness_on_sleep: 4
  dreamed: true

workout:
  bench_press: [ {weight: 135, reps: 5}, {weight: 135, reps: 5}, {weight: 135, reps: 4, negatives: true} ]
  cardio: [ {weight: 135, reps: 5}, {weight: 135, reps: 5}, {weight: 135, reps: 4, negatives: true} ]
  feeling: 8

-->
  { name: workout
    details: [
      {
        name: bench_press
        children: [
          { name: bench_press set
            details:






THINGS TO TEST
  ember-data arrays
  ember-data codecs for 'polymorphic value'
  how to store arbitrarily complicated data?

  storing everything in the same model (Act.detail = DS.attr... something) --- works!
  having views descend from that model
    ember paths for non ember attrs?  arbitrary objects..

  enumerable (flat) object


  detail view.hbs:
  ===============

  {{#each in key val in json}}
    ifIsObject val
    ifIsArray val
    else
      key: value

  {{/each}}


Ember.EnumerableJSONObject
===
Besides asdfs


=end


