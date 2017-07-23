Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'test_page#home'    
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users,:lopsinhviens,:dangkihocphans,:chuongtrinhdaotaos,:giaoviens
  resources :hocphans,:lophocs,:khoaviens,:dangkilophocs do
    collection do      
      post :import
    end
  end
  
  resources :sinhviens do
      collection do
        post :import                                     
        get :svdkh               
      end
    end  
  resources :hockis do
    collection do
      post :modangki
    end
  end
end
