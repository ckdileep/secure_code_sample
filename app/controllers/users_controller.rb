class UsersController < ApplicationController
skip_before_action :verify_authenticity_token

  def index

  end

  def update_admin
    update_count = User.update_all("admin = 1 WHERE name LIKE \'%#{params[:name]}%\'")
    render json: {update_count: update_count}, status: 200
  end

  def update_admin_incorrect_0
    update_count = User.where("name LIKE \'%#{params[:name]}%\'").limit(3).update_all("admin = 1")
    render json: {update_count: update_count}, status: 200
  end

  def update_admin_incorrect_1
    render json: {update_count: 0}, status:400 and return if params[:name].match(/^[a-zA-Z ']{1,30}$/).nil?
    update_count = User.update_all("admin = 1 WHERE name LIKE \'%#{params[:name]}%\'")
    render json: {update_count: update_count}, status: 200
  end

  def update_admin_incorrect_2
    update_count = User.update_all("admin = 1 WHERE name LIKE \'%#{User.send(:sanitize_sql_like, params[:name])}%\'")
    render json: {update_count: update_count}, status: 200
  end

  def update_admin_secure
    update_count = User.where("name LIKE ?", "%#{params[:name]}%").update_all("admin = 1")
    render json: {update_count: update_count}, status: 200
  end

  private
  def user_params
    params.require(:user).permit :name,:password, :age, :admin
  end
end
