module LinkHitsController
  module_function

  def index(params)
    validate_params(params)
    LinkHit.find_by({ link_id: params[:id] })
  end

  def create(params)
    link = get_link(params[:id])
    LinkHit.create(link_hit_params(params.merge({ link_id: link["id"]})))
    link["original_link"]
  end

  def link_hit_params(params)
    { referrer: params[:ref], ip: params[:ip], link_id: params[:link_id] }
  end

  def get_link(id)
    link = Link.find_by({ short_link: id })
    if link.length >= 1
      link.first
    else
      raise Exception, "Link not found."
    end
  end

  def validate_params(params)
    if params[:id].nil?
      raise ArgumentError, "ID must be provided."
    else
      true
    end
  end
end
