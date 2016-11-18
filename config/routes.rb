Rails.application.routes.draw do
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'test_page#home'    
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  get '/hocphans'=> 'hocphans#index'
  get '/lophocs'=>'lophocs#index'
  get '/canhans/chuongtrinhdaotao'=>'canhans#chuongtrinhdaotao'
  get '/canhans/dangkihoctap'=>'canhans#dangkihoctap'
  get '/canhans/thoikhoabieu'=>'canhans#thoikhoabieu'
  get '/canhans/thoikhoabieu'=>'canhans#bangdiem'
  get '/canhans/thongtin'=>'canhans#thongtin'
  get '/canhans/hocphi'=>'canhans#hocphi'
  get 'canhans/bangdiem'=>'<canhans id="bangdiem"></canhans>'
  get '/dangkilophocs'=>'dangkilophocs#index'
  get '/dangkihocphans'=>'dangkihocphans#index'
  get '/lopsinhviens'=>'lopsinhviens#index'

end
