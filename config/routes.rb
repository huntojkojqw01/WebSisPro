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
    resources :static_pages do
          collection do
        get :my_data
      end
    end
  get '/canhans/chuongtrinhdaotao'=>'canhans#chuongtrinhdaotao'
  get '/canhans/dangkihoctap'=>'canhans#dangkihoctap'
  get '/canhans/thoikhoabieu'=>'canhans#thoikhoabieu'
  get '/canhans/bangdiem'=>'canhans#bangdiem'
  get '/canhans/thongtin'=>'canhans#thongtin'
  get '/canhans/hocphi'=>'canhans#hocphi'
  get 'canhans/bangdiem'=>'<canhans id="bangdiem"></canhans>'
  
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
        get :sinhviendangkihoc
      end
    end
    resources :dangkilophocs do
      collection {post :import}
    end
  resources :giaoviens
  resources :hockis

end
