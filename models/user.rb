# frozen_string_literal: true

require 'bcrypt'

class User
  include BCrypt

  def initialize(email, raw_password)
    @email = email
    @hashed_password = Password.create(raw_password)
    @token = SecureRandom.hex(12)
    @db = Lib::HarperOrm.new
  end

  def save
    if exists?({ email: @email })
      raise 'User with this email already exists.'
    else
      @db.create_record('users', { email: @email, password: @hashed_password, token: @token })
    end
  end

  def self.validate(params)
    found_user = find_by({ email: params[:email] }).first
    if found_user.length.zero?
      raise 'User is not registered with this email.'
    elsif Password.new(found_user['password']) != params[:password]
      raise 'Either email or password is incorrect!'
    else
      found_user
    end
  end

  def self.create(params)
    if exists?({ email: params[:email] })
      raise 'User with this email already exists.'
    else
      Lib::HarperOrm.new.create_record(
        'users',
        {
          email: params[:email],
          password: Password.create(params[:password]),
          token: SecureRandom.hex(12)
        }
      )
    end
  end

  def self.find_by(params)
    Lib::HarperOrm.new.find_by('users', params.keys.first, params.values.first)
  end

  def self.find(id)
    Lib::HarperOrm.new.find('users', id)
  end

  def self.exists?(params)
    find_by(params).length >= 1
  end

  def self.all
    Lib::HarperOrm.new.all_records('users')
  end
end
