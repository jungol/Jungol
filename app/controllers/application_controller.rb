class ApplicationController < ActionController::Base
  protect_from_forgery
  include PermissionsHelper

  before_filter InvitationFilter

end
