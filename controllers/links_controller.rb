module LinksController
  module_function

  def create(params)
    # link_params is used to validate the params
    params = link_params(params)

    random_str = short_link

    Link.create(link_params(params).merge({ short_link: random_str }))

    # generated random_str is returned just to prevent an extra
    # call to HarperDB for getting the same value from links table
    random_str
  end


  def link_params(params)
    if params[:original_link].nil?
      raise ArgumentError, "Original link must be provided."
    else
      { original_link: params[:original_link], title: params[:title], user_id: params[:user_id] }
    end
  end

  def short_link
    random_str = SecureRandom.hex(3)
    if Link.exists?({ short_link: random_str })
      short_link
    else
      random_str
    end
  end
end
