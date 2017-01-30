Rails.application.routes.draw do
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'test_page#home'
  get '/sieu', to: 'test_page#sieu'    
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :hocphans do
    collection do
      get :search
    end
  end
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
        get :duyet
        post :duyet
        get :search
      end
    end
  resources :dangkilophocs do
      collection do
        post :import        
      end
    end
  resources :giaoviens do
    collection do
      get :search
    end
  end
  resources :hockis
end
