# frozen_string_literal: true

class LinkHit
  def initialize(link_id, _ip, referrer)
    ip_data = Utils.get_location(params[:id])
    @link_id = link_id
    @location = "#{ip_data['city']}/#{ip_data['country_name']}"
    @referrer = referrer
    @db = Lib::HarperOrm.new
  end

  def save
    @db.create_record('link_hits', {
                        link_id: @link_id,
                        location: @location,
                        referrer: @referrer
                      })
  end

  def self.create(params)
    ip_data = Utils.get_location(params[:ip])
    Lib::HarperOrm.new.create_record(
      'link_hits',
      {
        link_id: params[:link_id],
        location: "#{ip_data['city']}/#{ip_data['country_name']}",
        referrer: params[:referrer] || 'Direct Link'
      }
    )
  end

  def self.find_by(params)
    Lib::HarperOrm.new.find_by('link_hits', params.keys.first, params.values.first)
  end

  def self.find(id)
    Lib::HarperOrm.new.find('link_hits', id)
  end

  def self.first
    Lib::HarperOrm.new.first('link_hits')
  end
end
