Refinery::Core::Engine.routes.append do

  # Admin routes
  namespace :longdrinks, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :longdrinks, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
