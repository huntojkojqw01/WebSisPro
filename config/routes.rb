Rails.application.routes.draw do
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'test_page#home'    
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :hocphans
  resources :lophocs do
      collection { post :import }
    end
  resources :dangkihocphans,:chuongtrinhdaotaos
  resources :khoaviens
  resources :lopsinhviens
  resources :sinhviens do
      collection do
        post :import
        get :thoikhoabieu
        get :bangdiem
        get :dangkilophoc
        get :dangkihocphan
        get :chuongtrinhdaotao
        get :svdkh
      end
    end
  resources :dangkilophocs do
      collection do
        post :import        
      end
    end
  resources :giaoviens
  resources :hockis
end
