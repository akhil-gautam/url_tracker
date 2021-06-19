# frozen_string_literal: true

class Link
  def initialize(original_link, short_link, title, user_id)
    @original_link = original_link
    @short_link = short_link
    @title = title
    @user_id = user_id
    @db = Lib::HarperOrm.new
  end

  def save
    if exists?({ short_link: @short_link })
      raise 'Already taken.'
    else
      @db.create_record('links', {
                          short_link: @short_link,
                          original_link: @original_link,
                          title: @title,
                          user_id: @user_id
                        })
    end
  end

  def self.validate(params)
    found_link = find_by({ short_link: params[:short_link] }).first
    if !found_link.empty?
      raise 'Already taken.'
    else
      true
    end
  end

  def self.create(params)
    if exists?({ short_link: params[:short_link] })
      raise 'Already taken.'
    else
      Lib::HarperOrm.new.create_record(
        'links',
        {
          short_link: params[:short_link],
          original_link: smart_add_url_protocol(params[:original_link]),
          title: params[:title],
          user_id: params[:user_id]
        }
      )
    end
  end

  def self.update(params)
    Lib::HarperOrm.new.update(
      'links',
      {
        short_link: params[:short_link],
        original_link: smart_add_url_protocol(params[:original_link]),
        title: params[:title],
        id: params[:id]
      }
    )
  end

  def self.find_by(params)
    Lib::HarperOrm.new.find_by('links', params.keys.first, params.values.first)
  end

  def self.find(id)
    Lib::HarperOrm.new.find('links', id)
  end

  def self.exists?(params)
    result = find_by(params)
    result.is_a?(Array) && result.length >= 1
  end

  def self.smart_add_url_protocol(url)
    return "https://#{url}" unless url[%r{\Ahttp://}] || url[%r{\Ahttps://}]

    url
  end
end
