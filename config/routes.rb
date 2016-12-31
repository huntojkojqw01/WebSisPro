Rails.application.routes.draw do
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'test_page#home'    
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :hocphans
  resources :lophocs do
      collection { post :import }
    end
  get '/canhans/chuongtrinhdaotao'=>'canhans#chuongtrinhdaotao'
  get '/canhans/dangkihoctap'=>'canhans#dangkihoctap'
  get '/canhans/thoikhoabieu'=>'canhans#thoikhoabieu'
  get '/canhans/thoikhoabieu'=>'canhans#bangdiem'
  get '/canhans/thongtin'=>'canhans#thongtin'
  get '/canhans/hocphi'=>'canhans#hocphi'
  get 'canhans/bangdiem'=>'<canhans id="bangdiem"></canhans>'
  
  resources :dangkihocphans,:chuongtrinhdaotaos
  resources :khoaviens
  resources :lopsinhviens
  resources :sinhviens do
      collection { post :import }
    end
    resources :dangkilophocs do
      collection {post :import}
    end
  resources :giaoviens
  resources :hockis

end
