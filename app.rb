require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require_relative './model.rb'

enable :sessions

include Model

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
    result = get_characters_for_user(user_id)
    char_item_array = []
    result.each do |character|
      char_item_array << get_item_from_character_name(character["name"]) 
    end
    slim(:"characters",locals:{character:result,items:char_item_array})
  end
end

get('/characters/create') do
  if session[:id] == nil
    "Login first!"
  else
    user_id = session[:id]
    result = get_items_for_characters(user_id)
    slim(:"create",locals:{item:result})
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
    if validate_user_for_characters(params) == true
      user_id = session[:id]
      id = params[:id]
      result = get_items_for_characters(user_id)
      slim(:"edit",locals:{item:result,id:id})
    else
      "You can only change characters you own!"
    end
  end
end

post('/characters/:id/edit') do
  if session[:id] == nil
    "Login first!"
  else
    if validate_user_for_characters(params) == true
      id = params[:id]
      edit_character(id)
      redirect('/characters')
    else
      "You can only change characters you own!"
    end
  end
end


post('/characters/:id/delete') do
  if session[:id] == nil
    "Login first!"
  else
    if validate_user_for_characters(params) == true
      id = params[:id]
      delete_character(id)
      redirect('/characters')
    else
      "You can only delete characters you own!"
    end
  end
end

get('/items') do
  if session[:id] == nil
    "Login first!"
  else
    user_id = session[:id]
    result = get_items_for_user(user_id)
    slim(:"items",locals:{item:result})
  end
end

post('/items') do
  if session[:id] == nil
    "Login first!"
  else
    user_id = session[:id]
    id = session[:id].to_s
    new_item(id, user_id)
    redirect('/items')
  end
end

post('/items/:id/edit') do
  if session[:id] == nil
    "Login first!"
  else
    if validate_user_for_items(params) == true
      id = params[:id]
      item = params[:item]
      edit_item(id, item)
      redirect('/items')
    else
      "You can only change items you own!"
    end
  end
end

post('/items_damage/:id/edit') do
  if session[:id] == nil
    "Login first!"
  else
    if validate_user_for_items(params) == true
      id = params[:id]
      damage = params[:item].to_i
      edit_item_damage(id, damage)
      redirect('/items')
    else
      "You can only change items you own!"
    end
  end
end

post('/items/:id/delete') do
  if session[:id] == nil
    "Login first!"
  else
    if validate_user_for_items(params) == true
      id = params[:id]
      delete_item(id)
      redirect("/items")
    else
      "You can only change items you own!"
    end
  end
end