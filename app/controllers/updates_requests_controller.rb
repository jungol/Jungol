class UpdatesRequestsController < ApplicationController

  def create
    @ip = request.remote_ip
    req = UpdatesRequest.new(params[:updates_request])
    req.ip = @ip
    req.save!
      render :nothing => true
    rescue ActiveRecord::RecordInvalid => e
      render :text => e.message, :status => 403

  end

end
