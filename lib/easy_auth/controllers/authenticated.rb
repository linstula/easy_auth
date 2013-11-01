module EasyAuth::Controllers::Authenticated
  extend ActiveSupport::Concern

  included do
    before_filter :attempt_to_authenticate
  end

  private

  def attempt_to_authenticate(resource=nil)
    if account_not_signed_in?
      session[:requested_path] = request.path
      session[resource] = params[resource] if resource
      respond_to do |format|
        format.html { redirect_to main_app.sign_in_url }
        format.json { render :json => {}, :status => 401 }
      end
    end
  end

  def method_missing(resource, *args)
    resource_str = resource.to_s
    return resource_str[6..-1] if resource_str[/\Astash_/]
    super
  end
end
