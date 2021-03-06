class PagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:welcome]
  layout "lander"

  def welcome
    if user_signed_in?
      redirect_to filter_index_path
      return
    end
    @updates_request = UpdatesRequest.new
    @title = "Coming Soon"
    render :lander
  end

  def invite
    @user = current_user
    @title = "Invite User(s)"
    if request.get? #show invite form
      render :invite
    elsif request.post? #they submitted the form
      @recipients = request[:invitees].split(',').uniq
      email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

      @recipients.each do |email|
        email = email.strip
        if email_regex =~ email
          User.invite!({:email => email}, current_user)
          #Notifier.invite(@user, email).deliver
          flash[:success] ||= "<p>Emails delivered:</p><ul>"
          flash[:success] << "<li>"+ email + "</li>"
        else
          flash[:error] ||= "<p>Emails failed:</p><ul>"
          flash[:error] << "<li>"+ email + "</li>"
        end
      end

      if flash[:success]
        flash[:success] << "</ul>"
        flash[:success] = flash[:success].html_safe
      end

      if flash[:error]
        flash[:error] << "</ul>"
        flash[:error] = flash[:error].html_safe
      end
      redirect_to :invite
    else #not GET or POST
      redirect_to root_path
    end

  end

end
