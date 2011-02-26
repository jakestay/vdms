module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /the home\s?page/ then home_path
    when /the staff dashboard page/ then staff_dashboard_path
    when /the peer advisor dashboard page/ then peer_advisor_dashboard_path
    when /the faculty dashboard page/ then faculty_dashboard_path

    when /the update settings page/ then edit_settings_path

    when /the view staff page/ then staff_path
    when /the new staff page/ then new_staff_instance_path
    when /the import staff page/ then upload_staff_path
    when /the edit staff page/ then edit_staff_instance_path(@staff)
    when /the delete staff page/ then delete_staff_instance_path(@staff)

    when /the view peer advisors page/ then peer_advisors_path
    when /the new peer advisor page/ then new_peer_advisor_path
    when /the import peer advisors page/ then upload_peer_advisors_path
    when /the edit peer advisor page/ then edit_peer_advisor_path(@peer_advisor)
    when /the delete peer advisor page/ then delete_peer_advisor_path(@peer_advisor)

    when /the view faculty page/ then faculty_path
    when /the new faculty page/ then new_faculty_instance_path
    when /the import faculty page/ then upload_faculty_instance_path
    when /the edit faculty page/ then edit_faculty_instance_path(@faculty)
    when /the schedule faculty page/ then schedule_faculty_instance_path(@faculty)
    when /the rank admits page/ then rank_admits_faculty_instance_path(@faculty)
    when /the select admits page/ then select_admits_faculty_instance_path(@faculty)
    when /the delete faculty page/ then delete_faculty_instance_path(@faculty)
    when /the admit_ranking page/ then rank_admits_faculty_instance_path(@faculty)   
    when /the view faculty meeting schedule page$/ then faculty_meetings_path(@faculty)
    when /the view faculty meeting schedule page for "(.*) (.*)"/ then faculty_meetings_path(Faculty.find_by_first_name_and_last_name($1,$2))

    when /the view admits page/ then admits_path
    when /the new admit page/ then new_admit_path
    when /the import admits page/ then upload_admits_path
    when /the edit admit page/ then edit_admit_path(@admit)
    when /the schedule admit page/ then schedule_admit_path(@admit)
    when /the rank faculty page/ then rank_faculty_admit_path(@admit)
    when /the select faculty page/ then select_faculty_admit_path(@admit)
    when /the delete admit page/ then delete_admit_path(@admit)

    when /the master meetings page/  then master_meetings_path() 

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
