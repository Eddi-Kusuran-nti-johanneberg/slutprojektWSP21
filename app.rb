require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

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

get('/characters') do
  id = session[:id].to_i
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM characters WHERE user_id = ?",id)
  slim(:"characters",locals:{character:result})
end

get('/create') do
  slim(:create)
end

post('/create') do
  id = session[:id].to_i
  character = params[:character]
  strength = params[:strength].to_i
  intelligence = params[:intelligence].to_i
  willpower = params[:willpower].to_i
  agility = params[:agility].to_i
  speed = params[:speed].to_i
  endurance = params[:endurance].to_i
  personality = params[:personality].to_i
  luck = params[:luck].to_i
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.results_as_hash = true
  db.execute("INSERT INTO characters (name,strength,intelligence,willpower,agility,speed,endurance,personality,luck,user_id) VALUES (?,?,?,?,?,?,?,?,?,?)",character,strength,intelligence,willpower,agility,speed,endurance,personality,luck,id).first
  redirect('/characters')
end

get('/characters/:id/edit') do
  slim(:edit)
end

post('/characters/:id/edit') do
  id = params[:id].to_i
  character = params[:character]
  strength = params[:strength].to_i
  intelligence = params[:intelligence].to_i
  willpower = params[:willpower].to_i
  agility = params[:agility].to_i
  speed = params[:speed].to_i
  endurance = params[:endurance].to_i
  personality = params[:personality].to_i
  luck = params[:luck].to_i
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.results_as_hash = true
  db.execute("UPDATE characters SET name = ?, strength = ?, intelligence = ?, willpower = ?, agility = ?, speed = ?, endurance = ?, personality = ?, luck = ? WHERE id = ?",character,strength,intelligence,willpower,agility,speed,endurance,personality,luck,id).first
  redirect('/characters')
end

post('/characters/:id/delete') do
  id = params[:id].to_i
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.execute("DELETE FROM characters WHERE id = ?",id)
  redirect("/characters")
end

get('/items') do
  id = session[:id].to_i
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM items WHERE user_id = ?",id)
  slim(:"items",locals:{item:result})
end

post('/items') do
  id = session[:id].to_i
  item = params[:item]
  damage = params[:damage].to_i
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.results_as_hash = true
  db.execute("INSERT INTO items (name,damage,user_id) VALUES (?,?,?)",item,damage,id).first
  redirect('/items')
end

post('/items/:id/delete') do
  id = params[:id].to_i
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.execute("DELETE FROM items WHERE id = ?",id)
  redirect("/items")
end

post('/items/:id/edit') do
  id = params[:id].to_i
  item = params[:item]
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.results_as_hash = true
  db.execute("UPDATE items SET name=? WHERE id=?",item,id).first
  redirect('/items')
end

post('/items_damage/:id/edit') do
  id = params[:id].to_i
  damage = params[:item].to_i
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.results_as_hash = true
  db.execute("UPDATE items SET damage=? WHERE id=?",damage,id).first
  redirect('/items')
end

post('/login') do
  username = params[:username]
  password = params[:password]
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM users WHERE username = ?",username).first
  pwdigest = result["pwdigest"]
  id = result["id"]
    
  if BCrypt::Password.new(pwdigest) == password
    session[:id] = id
    redirect('/characters')
  else
    "Wrong password!"
  end
end

post("/register") do
  username = params[:username]
  password = params[:password]
  password_confirm = params[:password_confirm]

  if username != "" && password != "" && password_confirm != ""
    if password == password_confirm
      password_digest = BCrypt::Password.create(password)
      db = SQLite3::Database.new('db/slutprojektWSP21.db')
      db.execute("INSERT INTO users (username,pwdigest) VALUES (?,?)",username,password_digest)
      redirect('/characters')

    else
      "The passwords don't match!"
    end
  else
    "Fill in all fields please!"
  end
end

get('/logout') do
  if session[:id]
    session.destroy()
  end
  redirect("/")
end