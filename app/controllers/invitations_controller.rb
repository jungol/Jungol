class InvitationsController < Devise::InvitationsController
  def new
    @title = "Invite a user"
    @blurb = "Have a friend, co-worker, or acquaintance who would enjoy using Jungol? Send them an invitation to join today!"
    super
  end

  def edit
    @title = "Confirm your invitation"
    @blurb = "Hey there, thanks for coming to Jungol! Fill out your information below to get started."
    super
  end
end
