class UpdatesRequestsController < ApplicationController

  def create
    @ip = request.remote_ip
    req = UpdatesRequest.new(params[:updates_request])
    req.ip = @ip
    if req.save
      render :nothing => true
    else
      render :json => {:error => "fail!"}
    end

  end

end
