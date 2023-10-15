class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :ensure_normal_user, only: %i(update destroy)

  def new
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    if params[:user][:avatar].blank?
      params[:user].delete(:avatar)
    end
    super
  end

  def ensure_normal_user
    if resource.email == 'guest@example.com'
      if action_name == 'destroy'
        redirect_to root_path, alert: 'ゲストユーザーは削除できません。'
      elsif action_name == 'update'
        redirect_to user_path(current_user), alert: 'ゲストユーザーの再設定はできません。'
      end
    end
  end

  def destroy
    super
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end

  def after_sign_up_path_for(resource)
    user_path(resource)
  end
end
