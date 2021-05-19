require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require_relative './model.rb'

enable :sessions

get('/') do
  slim(:index)
end

get('/register') do
  slim(:register)
end

get('/showlogin') do
  slim(:login)
end

post('/login') do
  username = params[:username]
  password = params[:password]
  login_user(username, password)
end

post("/register") do
  username = params[:username]
  password = params[:password]
  password_confirm = params[:password_confirm]
  register_user(username, password, password_confirm)
end

get('/logout') do
  session.destroy()
  redirect("/")
end

get('/characters') do
  if session[:id] == nil
    "Login first!"
  else
    user_id = session[:id]
    get_characters_for_user(user_id)
  end
end

get('/characters/create') do
  if session[:id] == nil
    "Login first!"
  else
    slim(:create)
  end
end

post('/characters/create') do
  if session[:id] == nil
    "Login first!"
  else
    user_id = session[:id]
    new_character(user_id)
    redirect('/characters')
  end
end

get('/characters/:id/edit') do
  if session[:id] == nil
    "Login first!"
  else
    slim(:edit)
  end
end

post('/characters/:id/edit') do
  if session[:id] == nil
    "Login first!"
  else
    id = params[:id]
    edit_character(id)
    redirect('/characters')
  end
end

post('/characters/:id/delete') do
  if session[:id] == nil
    "Login first!"
  else
    id = params[:id]
    delete_character(id)
    redirect('/characters')
  end
end

get('/items') do
  if session[:id] == nil
    "Login first!"
  else
    user_id = session[:id]
    get_items_for_user(user_id)
  end
end

post('/items') do
  if session[:id] == nil
    "Login first!"
  else
    user_id = session[:id]
    new_item(user_id)
    redirect('/items')
  end
end

post('/items/:id/edit') do
  if session[:id] == nil
    "Login first!"
  else
    id = params[:id]
    item = params[:item]
    edit_item(id, item)
    redirect('/items')
  end
end

post('/items_damage/:id/edit') do
  if session[:id] == nil
    "Login first!"
  else
    id = params[:id].to_i
    damage = params[:item].to_i
    edit_item_damage(id, damage)
    redirect('/items')
  end
end

post('/items/:id/delete') do
  if session[:id] == nil
    "Login first!"
  else
    id = params[:id]
    delete_item(id)
    redirect("/items")
  end
end