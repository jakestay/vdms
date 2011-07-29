ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'root' do |root|
    root.home '', :action => 'home', :conditions => {:method => :get}
    root.sign_out 'sign_out', :action => 'sign_out', :conditions => {:method => :get}
    root.sign_out 'sign_out', :action => 'sign_out', :conditions => {:method => :delete}
    root.staff_dashboard 'staff', :action => 'staff_dashboard', :conditions => {:method => :get}
    root.peer_advisor_dashboard 'peer_advisor', :action => 'peer_advisor_dashboard', :conditions => {:method => :get}
    root.faculty_dashboard 'faculty', :action => 'faculty_dashboard', :conditions => {:method => :get}
  end

  map.resource :settings, :only => [:edit, :update]

  map.resources :meetings, :collection => {:create_all => :post, :master => :get, :statistics => :get, :print_admits => :get, :print_faculty => :get}

  map.resources :staff, :singular => 'staff_instance', :path_prefix => '/people',
    :except => [:show],
    :collection => {:upload => :get, :delete_all => :get, :import => :post, :destroy_all => :delete},
    :member => {:delete => :get}
  map.resources :peer_advisors, :path_prefix => '/people',
    :except => [:show],
    :collection => {:upload => :get, :delete_all => :get, :import => :post, :destroy_all => :delete},
    :member => {:delete => :get}
  map.resources :faculty, :singular => 'faculty_instance', :path_prefix => '/people',
    :except => [:show],
    :collection => {:upload => :get, :delete_all => :get, :import => :post, :destroy_all => :delete},
    :member => {:edit_availability => :get, :delete => :get}
  map.resources :faculty, :singular => 'faculty_instance', :path_prefix => '/people' do |faculty|
    faculty.resources :rankings, :controller => 'host_rankings', :only => :index, :collection => {:add => :get, :edit_all => :get, :update_all => :put}
    faculty.resources :meetings, :only => :index, :collection => {:tweak => :get, :apply_tweaks => :post}
  end
  map.resources :admits, :path_prefix => '/people',
    :except => [:show],
    :collection => {:upload => :get, :delete_all => :get, :import => :post, :destroy_all => :delete},
    :member => {:edit_availability => :get, :delete => :get}
  map.resources :admits, :path_prefix => '/people' do |admit|
    admit.resources :rankings, :controller => 'visitor_rankings', :only => :index, :collection => {:add => :get, :edit_all => :get, :update_all => :put}
    admit.resources :meetings, :only => :index
  end
end
