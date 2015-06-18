Searchjoy::Engine.routes.draw do
  resources :searches, only: [:index] do
    get "overview", on: :collection
    get "recent", on: :collection
  end
  root to: "searches#stream"
end
