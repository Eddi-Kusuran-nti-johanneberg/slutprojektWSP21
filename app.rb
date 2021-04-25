require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions

get('/') do
  slim(:home)
end

get('/register') do
  slim(:register)
end

get('/showlogin') do
  slim(:login)
end

get('/characters') do
  slim(:characters)
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

