Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post :visited_links, defaults: { format: :json }
      get :visited_domains, defaults: { format: :json }
    end
  end
end
