class ApplicationController < ActionController::Base
  def index
    render html: '<h1>Welcome to My App</h1>'.html_safe
  end
end
