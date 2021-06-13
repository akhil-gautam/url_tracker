module UsersController
  module_function

  def create(params)
    User.create(user_params(params))
  end

  def login(params)
    { token: User.validate(user_params(params))["token"] }
  end


  def user_params(params)
    if params[:email].nil? || params[:password].nil?
      raise ArgumentError, "Email and password must be provided."
    else
      { email: params[:email], password: params[:password] }
    end
  end
end
