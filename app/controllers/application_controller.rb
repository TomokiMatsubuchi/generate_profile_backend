class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # 以下を有効にするとdevise認証のみcsrfトークンを無効化できる。
  # TODO: あまり好ましくないので、https://midorimici.com/posts/rails-api-csrfを参考に修正する。
  skip_before_action :verify_authenticity_token, if: :devise_controller?, raise: false
  before_action do
    I18n.locale = :ja
  end
end
