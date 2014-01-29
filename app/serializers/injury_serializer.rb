class InjurySerializer < EventSerializer
  attributes :source, :return_date, :quote, :status, :body_part

  has_one :player
end
