Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post :visited_links, defaults: { format: :json }, to: 'base#visited_links'
      get :visited_domains, defaults: { format: :json }, to: 'base#visited_domains'
    end
  end
end
