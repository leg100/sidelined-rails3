class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :long_name, :short_name, :ticker_and_name, :slug, :template_url, :version
  has_one :club
  has_one :modifier

  has_many :revisions, serializer: HistoryTrackerSerializer
  def revisions
    HistoryTracker.includes(:modifier).where(:association_chain.elem_match => {id: id})
      .desc(:version)
  end

  def ticker_and_name
   object.short_name + ' ' + object.long_name
  end

  def template_url
    "/views/widgets/player.html"
  end
end
