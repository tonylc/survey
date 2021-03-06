ActionController::Routing::Routes.draw do |map|
  map.resources :families

  map.resources :users, :member => { :suspend   => :put,
                                     :unsuspend => :put,
                                     :purge     => :delete,
                                     :edit      => :post }
  map.resource  :session
  
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.admin '/admin', :controller => 'admin', :action => 'index'
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.reset_password '/reset_password/:id', :controller => 'users', :action => 'reset_password'

  map.home '/', :controller => 'home', :action => 'index'
  map.home '/home', :controller => 'home', :action => 'index'
 

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  #map.connect ':controller/:action:format'
end
