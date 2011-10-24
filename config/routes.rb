ActionController::Routing::Routes.draw do |map|
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
      :collection => {:create_all => :get, :statistics => :get}
    )
  end

  map.root :events
end
