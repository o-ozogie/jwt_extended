require 'jwt'
require 'active_support/duration'
require 'action_controller/api'


class JWTBase < ActionController::API

  def initialize(secret_key, access_exp, refresh_exp)
    @secret_key = secret_key
    @access_exp = access_exp
    @refresh_exp = refresh_exp
    @algorithm = 'HS256'

    raise Time::TypeError unless @access_exp.class == ActiveSupport::Duration
    raise Time::TypeError unless @refresh_exp.class == ActiveSupport::Duration
  end

  def create_access_token(payload)
    raise JWT::EncodeError unless payload[:exp].nil? || payload[:type].nil?

    payload[:exp] = (Time.now + @access_exp).to_i
    payload[:type] = :access_token
    JWT.encode(payload, @secret_key, @algorithm)
  end

  def create_refresh_token(payload)
    raise JWT::EncodeError unless payload[:exp].nil? || payload[:type].nil?

    payload[:exp] = (Time.now + @refresh_exp).to_i
    payload[:type] = :refresh_token
    JWT.encode(payload, @secret_key, @algorithm)
  end

  def token_required(token)
    payload = JWT.decode(token, @secret_key, @algorithm)[0]
  rescue JWT::DecodeError || NoMethodError
    { error: :unauthorized }
  rescue JWT::ExpiredSignature
    { error: :gone }
  else
    payload
  end

  def jwt_required(token)
    payload = token_required(token)
    return { status: payload[:error] } if payload[:error]
    return { status: :forbidden } unless payload['type'] == 'access_token'

    payload
  end

  def refresh_token_required(token)
    payload = token_required(token)
    return { status: payload[:error] } if payload[:error]
    return { status: :forbidden } unless payload['type'] == 'refresh_token'

    payload
  end
end

