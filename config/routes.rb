ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'root' do |root|
    root.home '', :action => 'home', :conditions => {:method => :get}
    root.sign_out 'sign_out', :action => 'sign_out', :conditions => {:method => :get}
    root.sign_out 'sign_out', :action => 'sign_out', :conditions => {:method => :delete}
    root.staff_dashboard 'staff', :action => 'staff_dashboard', :conditions => {:method => :get}
    root.peer_advisor_dashboard 'peer_advisor', :action => 'peer_advisor_dashboard', :conditions => {:method => :get}
    root.faculty_dashboard 'faculty', :action => 'faculty_dashboard', :conditions => {:method => :get}
  end

  map.resources(
    :people,
    :collection => {:upload => :get, :delete_all => :get, :import => :post, :destroy_all => :delete},
    :member => {:delete => :get}
  )

  map.resources(
    :events,
    :member => {:delete => :get}
  ) do |event|
    event.resources(
      :hosts,
      :except => :all
    ) do |host|
      host.resources(
        :rankings, :controller => 'host_rankings',
        :only => :index,
        :collection => {:add => :get, :edit_all => :get, :update_all => :put}
      )

      host.resources(
        :availabilities, :controller => 'host_availabilities',
        :except => :all,
        :collection => {:edit_all => :get, :update_all => :put}
      )

      host.resources(
        :meetings,
        :only => :index,
        :collection => {:tweak => :get, :apply_tweaks => :post}
      )
    end

    event.resources(
      :visitors
    ) do |visitor|
      visitor.resources(
        :rankings, :controller => 'visitor_rankings',
        :only => :index,
        :collection => {:add => :get, :edit_all => :get, :update_all => :put}
      )

      visitor.resources(
        :availabilities,
        :controller => 'visitor_availabilities',
        :except => :all,
        :collection => {:edit_all => :get, :update_all => :put}
      )

      visitor.resources(
        :meetings,
        :only => :index
      )
    end

    event.resources(
      :meetings,
      :only => :index,
      :collection => {:generate => :get}
    )
  end
end
