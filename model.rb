require 'sqlite3'
require 'bcrypt'


def login_user(username, password)
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

def register_user(username, password, password_confirm)
  if username != "" && password != "" && password_confirm != ""
    if password == password_confirm
      password_digest = BCrypt::Password.create(password)
      db = SQLite3::Database.new('db/slutprojektWSP21.db')
      db.execute("INSERT INTO users (username,pwdigest) VALUES (?,?)",username,password_digest)
      db.results_as_hash = true
      result = db.execute("SELECT * FROM users WHERE username = ?",username).first
      id = result["id"]
      session[:id] = id
      redirect('/characters')

    else
      "The passwords don't match!"
    end
  else
    "Fill in all fields please!"
  end
end

def get_characters_for_user(user_id)
  if session[:id] == nil
    "Login first!"
  #elsif session[:id] == "1"
  #  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  #  db.results_as_hash = true
  #  result = db.execute("SELECT * FROM characters")
  #  slim(:"characters",locals:{character:result})
  else
    id = session[:id].to_s
    db = SQLite3::Database.new('db/slutprojektWSP21.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM characters WHERE user_id = ?",id)
    slim(:"characters",locals:{character:result})
  end
end

def new_character(user_id)
  id = session[:id].to_s
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
end

def edit_character(id)
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
end

def delete_character(id)
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.execute("DELETE FROM characters WHERE id = ?",id)
end

def get_items_for_user(user_id)
  if session[:id] == nil
    "Login first!"
  else
    id = session[:id].to_s
    db = SQLite3::Database.new('db/slutprojektWSP21.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM items WHERE user_id = ?",id)
    slim(:"items",locals:{item:result})
  end
end

def new_item(user_id)
  id = session[:id].to_s
  item = params[:item]
  damage = params[:damage].to_i
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.results_as_hash = true
  db.execute("INSERT INTO items (name,damage,user_id) VALUES (?,?,?)",item,damage,id).first
end

def edit_item(id, item)
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.results_as_hash = true
  db.execute("UPDATE items SET name=? WHERE id=?",item,id).first
end

def edit_item_damage(id, damage)
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.results_as_hash = true
  db.execute("UPDATE items SET damage=? WHERE id=?",damage,id).first
end

def delete_item(id)
  db = SQLite3::Database.new('db/slutprojektWSP21.db')
  db.execute("DELETE FROM items WHERE id = ?",id)
end