Rails.application.routes.draw do

  resources :themes
    root 'board#index'
    
    get'/boards' => 'board#index'
    get'/board/new' => 'board#new'
    get'/board/:id' => 'board#show'
    post'/boards' =>'board#create'
    get'board/:id/edit' =>'board#edit'
    put '/board/:id' => 'board#update'
    patch '/board/:id' => 'board#update'
    delete '/board/:id' =>'board#destroy'
    
    # 가장 restful하게 짜져있는 구조얌~!~!
    
    get '/users' => 'user#index'
    get '/sign_up' => 'user#new'
    get '/sign_in' => 'user#sign_in'
    post '/sign_in' =>'user#login'
    get '/logout' => 'user#logout'
    post '/users' =>'user#create'
    get '/user/:id' => 'user#show'
    get '/user/:id/edit' => 'user#edit'
    put '/user/:id' => 'user#update'
    patch '/user/:id' =>'user#update'
    
    
    get '/caves' => 'cafe#index'
    get '/cafe/new' => 'cafe#new'
    post '/caves' => 'cafe#create'
    get '/cafe/:id' => 'cafe#show'
    get '/cafe/:id/edit' =>'cafe#edit'
    put '/cafe/:id' => 'cafe#update'
    patch '/cafe/:id' => 'cafe#update'
    delete '/cafe/:id' =>'cafe#destroy'
    
    




  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
