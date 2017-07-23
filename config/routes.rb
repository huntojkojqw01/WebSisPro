Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'test_page#home'    
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/locale',to: 'locale#create'
  resources :users,:lopsinhviens,:dangkihocphans,:chuongtrinhdaotaos,:giaoviens,:hockis
  resources :sinhviens,:hocphans,:lophocs,:khoaviens,:dangkilophocs do
    collection do      
      post :import
    end
  end  
end
