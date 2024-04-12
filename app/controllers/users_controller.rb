class UsersController < ApplicationController
  before_action :authenticate_user, only: %w[info index update]

  def create
    user = User.new(
      email: params[:email],
      password: params[:password],
      name: params[:name],
      nickname: params[:username]
    )

    rsa_key_1 = OpenSSL::PKey::RSA.new(2048)
    public_key_encrypt = rsa_key_1.public_key.to_pem
    private_key_decrypt = rsa_key_1.to_pem

    rsa_key_2 = OpenSSL::PKey::RSA.new(2048)
    public_key_decrypt = rsa_key_2.public_key.to_pem
    private_key_encrypt = rsa_key_2.to_pem

    user.pub_key = public_key_encrypt
    user.priv_key = private_key_encrypt

    if user.save
      token = JsonWebToken.encode(user_id: user.id)

      render json: { token: token, privKey: private_key_decrypt, pubKey: public_key_decrypt, userData: UserBlueprint.render_as_json(user) }
    else
      render json: { error: user.errors }, status: :unauthorized
    end
  end

  def index
    users = User.all
    render json: UserBlueprint.render_as_json(users)
  end

  def update
    if params[:oldPassword].blank? || @current_user.valid_password?(params[:oldPassword])
      @current_user.password = params[:password] if params[:password].present?
      @current_user.email = params[:email] if params[:email].present?
      @current_user.name = params[:name] if params[:name].present?
      @current_user.nickname = params[:nickname] if params[:nickname].present?
      @current_user.image = params[:image] if params[:image].present?

      rsa_key_1 = OpenSSL::PKey::RSA.new(2048)
      public_key_encrypt = rsa_key_1.public_key.to_pem
      private_key_decrypt = rsa_key_1.to_pem
  
      rsa_key_2 = OpenSSL::PKey::RSA.new(2048)
      public_key_decrypt = rsa_key_2.public_key.to_pem
      private_key_encrypt = rsa_key_2.to_pem
  
      @current_user.pub_key = public_key_encrypt
      @current_user.priv_key = private_key_encrypt
      if @current_user.save
        token = JsonWebToken.encode(user_id: @current_user.id)
        render json: { token: token, privKey: private_key_decrypt, pubKey: public_key_decrypt, userData: UserBlueprint.render_as_json(@current_user) }
      else
        render json: { error: @current_user.errors }, status: :unauthorized
      end
    else
      render json: {}, status: :unauthorized
    end
  end

  def auth
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      rsa_key_1 = OpenSSL::PKey::RSA.new(2048)
      public_key_encrypt = rsa_key_1.public_key.to_pem
      private_key_decrypt = rsa_key_1.to_pem

      rsa_key_2 = OpenSSL::PKey::RSA.new(2048)
      public_key_decrypt = rsa_key_2.public_key.to_pem
      private_key_encrypt = rsa_key_2.to_pem

      user.pub_key = public_key_encrypt
      user.priv_key = private_key_encrypt
      user.save

      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, privKey: private_key_decrypt, pubKey: public_key_decrypt, userData: UserBlueprint.render_as_json(user) }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def info
    render json: UserBlueprint.render_as_json(@current_user)
  end
end
