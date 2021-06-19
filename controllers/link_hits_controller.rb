# frozen_string_literal: true

module LinkHitsController
  module_function

  def index(params)
    validate_params(params)
    LinkHit.find_by({ link_id: params[:id] })
  end

  def analytics(params)
    validate_params(params)
    hits = LinkHit.find_by({ link_id: params[:id] })
    return nil if hits.length.zero?

    location = {}
    referrer = {}
    hits.each do |h|
      if location.include? h['location']
        location[h['location']] += 1
      else
        location[h['location']] = 1
      end
      if referrer.include? h['referrer']
        referrer[h['referrer']] += 1
      else
        referrer[h['referrer']] = 1
      end
    end
    { location: location, referrer: referrer }
  end

  def create(params)
    link = get_link(params[:id])
    LinkHit.create(link_hit_params(params.merge({ link_id: link['id'] })))
    link['original_link']
  end

  def link_hit_params(params)
    { referrer: params[:ref], ip: params[:ip], link_id: params[:link_id] }
  end

  def get_link(id)
    link = Link.find_by({ short_link: id })
    if link.length >= 1
      link.first
    else
      raise StandardError, 'Link not found.'
    end
  end

  def validate_params(params)
    if params[:id].nil?
      raise ArgumentError, 'ID must be provided.'
    else
      true
    end
  end
end
