module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
   case page_name

    when /^the signin page$/
      '/users/sign_in'

    when /^the filter page$/
      '/filter'

    when /^(.*)'s page$/
      group_path(Group.find_by_name($1).id)

    when /^(.*)'s new todo page$/
      new_group_todo_path(Group.find_by_name($1).id)

    when /^(.*)'s new discussion page$/
      new_group_discussion_path(Group.find_by_name($1).id)

    when /^the home\s?page$/
      '/'

    when /^the group\s?page$/
      '/groups'

    when /^my profile\s?page$/
      user_path(default_user.id)


    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
