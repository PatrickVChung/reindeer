Rails.application.routes.draw do

  resources :artifacts do
     member do
       delete :delete_document_attachment
       get 'move_files'
       get 'step_2_move_files'
       get 'process_preceptor_eval'
       get 'process_formative_feedback'
       get 'process_comp_excel'
       get 'process_bls_excel'

     end

     collection do

       get 'get_sub_components'

     end

  end

  get 'reports/index'

  #get 'student_assessments/index'


  get '/search' => 'searches#search', as: 'search_searches'
  get '/searches/download_file'

  devise_for :users

  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  mount ActionCable.server => "/cable"

  resources :messages

  resources :dashboard, controller: :dashboard, as: :dashboards, except: [:new]
  get "dashboard/:id/widgets/:widget_id", to: "dashboard#show_widget",
   constraints: { id: /\d+/, widget_id: /\d+/ }, as: "show_widget"


  #resources :users , controller: :users, param: :username, only: [:show, :update]
  resources :users do
    collection do
        get "update_loa", action: :update_loa, to: "users#update_loa#"
        get "save_update_loa", action: :save_update_loa, to: "users#save_update_loa"
    end
  end

  root to: "dashboard#index"

  #root to: redirect('/dashboard', status: 302)

  # Error routing
  get "errors/file_not_found"
  get "errors/unprocessable"
  get "errors/internal_server_error"
  get "errors/not_authorized"
  match "/401", to: "errors#not_authorized", via: :all
  match "/404", to: "errors#file_not_found", via: :all
  match "/422", to: "errors#unprocessable", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  #match '*unmatched', to: 'application#route_not_found', via: :all   # this will break the activestorage url_for(document) - make the document not viewable.

  get "pages/*id", to: "high_voltage/pages#show", as: :page, format: false

  #match "*any", via: :all, to: "errors#file_not_found"
end
