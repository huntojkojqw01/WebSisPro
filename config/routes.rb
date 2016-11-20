Rails.application.routes.draw do
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'test_page#home'    
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :hocphans,only: [:index]
  resources :lophocs, only: [:index,:show]
  get '/canhans/chuongtrinhdaotao'=>'canhans#chuongtrinhdaotao'
  get '/canhans/dangkihoctap'=>'canhans#dangkihoctap'
  get '/canhans/thoikhoabieu'=>'canhans#thoikhoabieu'
  get '/canhans/thoikhoabieu'=>'canhans#bangdiem'
  get '/canhans/thongtin'=>'canhans#thongtin'
  get '/canhans/hocphi'=>'canhans#hocphi'
  get 'canhans/bangdiem'=>'<canhans id="bangdiem"></canhans>'
  resources :dangkilophocs, only: [:index,:show]
  get '/dangkihocphans'=>'dangkihocphans#index'
  resources :lopsinhviens,only: [:show]
  resources :sinhviens,only: [:index,:show]

end
