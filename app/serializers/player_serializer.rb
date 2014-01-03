class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :long_name, :short_name, :ticker_and_name

  def ticker_and_name
   object.short_name + ' ' + object.long_name
  end
end


