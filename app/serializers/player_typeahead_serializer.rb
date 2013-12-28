class PlayerTypeaheadSerializer < ActiveModel::Serializer
  attributes :id, :ticker_and_name 

  def ticker_and_name
    "%s %s" % [object.short_name, object.long_name]
  end
end
