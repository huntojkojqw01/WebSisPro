Rails.application.routes.draw do
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'test_page#home'
  get '/hocphan', to: 'hoc_phan#index'
  get '/sinhvien', to: 'sinh_vien#index'
  get '/giaovien', to: 'giao_vien#index'
  get '/lophoc', to: 'lop_hoc#index'
  get '/dklop', to: 'dang_ki_lop#index'
  get '/bangdiem', to: 'bang_diem#index'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  

end
