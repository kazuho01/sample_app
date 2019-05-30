Rails.application.routes.draw do

  root 'static_pages#home'

  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  get 'signup', to: 'users#new'
  post '/signup',  to: 'users#create' # 「リスト 7.26」で追加

  resources :users
    #ユーザー情報を表示するURL（/users/1）を追加するだけではない
    #RESTfulなUsersリソースで必要となる全てのアクションが利用できるようになる

end
