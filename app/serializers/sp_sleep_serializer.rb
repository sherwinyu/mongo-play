class SpSleepSerializer < ActiveModel::Serializer
  attributes *%w[
    awake_at
    awake_energy
    up_at
    up_energy
  ]
end