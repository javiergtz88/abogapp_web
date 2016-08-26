require 'api/v1/api_v1_controller'

class Api::V1::ContentController < Api::V1::ApiController
  load_and_authorize_resource :user

  respond_to :json

  # GET contents/
  def index
    return failure(401, message: 'Login Failed', info: 'Api::V1::ContentController#failure') unless current_user
    page_no = params[:page] || 0
    json = HTTParty.get "#{content_domain}posts?context=index&page=#{page_no}", verify: false
    begin
      success json, info: 'Api::V1::ContentController#index'
    rescue
      return failure(400, message: "#{$ERROR_INFO}", info: 'Api::V1::ContentController#failure')
    end
  end

  # metodo que regresa un post
  # POST contents/search
  def search
    return failure(401, message: 'Login Failed', info: 'Api::V1::ContentController#failure') unless current_user
    json = HTTParty.get "#{content_domain}posts?context=search&filter[s]=#{params[:search]}", verify: false
    begin
      success json, info: 'Api::V1::ContentController#index'
    rescue
      return failure(400, message: "#{$ERROR_INFO}", info: 'Api::V1::ContentController#failure')
    end
  end

  # metodo que debe de regrasar un get
  # GET contents/article
  def article
    return failure(401, message: 'Login Failed', info: 'Api::V1::ContentController#failure') unless current_user
    json = HTTParty.get "#{content_domain}posts?filter[p]=#{params[:id]}", verify: false
    first_post = JSON.parse(json.body)[0]
    begin
      success first_post, info: 'Api::V1::ContentController#index'
    rescue
      return failure(400, message: "#{$ERROR_INFO}", info: 'Api::V1::ContentController#failure')
    end
  end

  private

  def content_domain
    'http://contents.appbogado.com.mx/wp-json/'
  end
end
