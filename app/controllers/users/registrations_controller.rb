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
    @purposes = PurposeOfMeditation.all
    super
  end

  def update
    if params[:user][:avatar].blank?
      params[:user].delete(:avatar)
    end
    @purposes = PurposeOfMeditation.all
    super
  end

  def ensure_normal_user
    if resource.email == 'guest@example.com' && action_name == 'destroy'
      redirect_to root_path, alert: 'ゲストユーザーは削除できません。'
    end
  end

  def destroy
    super
  end

  def update_resource(resource, params)
    if resource.guest?
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar, :purpose_of_meditation_id])
  end

  def after_sign_up_path_for(resource)
    user_path(resource)
  end
end
