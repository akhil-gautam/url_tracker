module LinksController
  module_function

  def index(params)
    # Commented this out to save API call latency.
    # validate_user(params)
    validate_params(params)
    Link.find_by({user_id: params[:id] })
  end

  def create(params)
    # link_params is used to validate the params
    params = link_params(params)

    random_str = short_link

    Link.create(link_params(params).merge({ short_link: random_str }))

    # generated random_str is returned just to prevent an extra
    # call to HarperDB for getting the same value from links table
    random_str
  end

  def show(params)
    Link.find_by(params).first
  end

  def update(params)
    validate_params(params)
    params.delete(:token)
    r = Link.update({
      id: params[:id],
      short_link: params[:short_link],
      original_link: params[:original_link],
      title: params[:title]
    })
  end

  def link_params(params)
    if params[:original_link].nil?
      raise ArgumentError, "Original link must be provided."
    else
      { original_link: params[:original_link], title: params[:title], user_id: params[:user_id] }
    end
  end

  def validate_params(params)
    if params[:id].nil?
      raise ArgumentError, "ID must be provided."
    else
      true
    end
  end

  # Commented this out to save API call latency.
  # def validate_user(params)
  #   user = User.find_by({ token: params[:token]}).first
  #   if user["id"] == params["id"]
  #     true
  #   else
  #     raise Exception, "Unable to validate the user."
  #   end
  # end

  def short_link
    random_str = SecureRandom.hex(3)
    if Link.exists?({ short_link: random_str })
      short_link
    else
      random_str
    end
  end
end
