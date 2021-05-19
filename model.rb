require 'sqlite3'
require 'bcrypt'

def db_connection()
  db = SQLite3::Database.new("db/slutprojektWSP21.db")
  db.results_as_hash = true
  return db
end

def login_user(username, password)
  result = db_connection().execute("SELECT * FROM users WHERE username = ?",username).first
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
      db_connection().execute("INSERT INTO users (username,pwdigest) VALUES (?,?)",username,password_digest)
      result = db_connection().execute("SELECT * FROM users WHERE username = ?",username).first
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

def get_characters_and_items_for_user(user_id)
  result = db_connection().execute("SELECT * FROM characters WHERE user_id = ?",user_id)
  slim(:"characters",locals:{character:result})
  result2 = db_connection().execute("SELECT * FROM items WHERE user_id = ?",user_id)
  slim(:"characters",locals:{item:result2})
end


def new_character(user_id)
  character = params[:character]
  strength = params[:strength].to_i
  intelligence = params[:intelligence].to_i
  willpower = params[:willpower].to_i
  agility = params[:agility].to_i
  speed = params[:speed].to_i
  endurance = params[:endurance].to_i
  personality = params[:personality].to_i
  luck = params[:luck].to_i
  db_connection().execute("INSERT INTO characters (name,strength,intelligence,willpower,agility,speed,endurance,personality,luck,user_id) VALUES (?,?,?,?,?,?,?,?,?,?)",character,strength,intelligence,willpower,agility,speed,endurance,personality,luck,user_id).first
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
  db_connection().execute("UPDATE characters SET name=?, strength=?, intelligence=?, willpower=?, agility=?, speed=?, endurance=?, personality=?, luck=? WHERE id=?",character,strength,intelligence,willpower,agility,speed,endurance,personality,luck,id).first
end

def delete_character(id)
  db_connection().execute("DELETE FROM characters WHERE id = ?",id)
end

def get_items_for_user(user_id)
  id = session[:id].to_s
  result = db_connection().execute("SELECT * FROM items WHERE user_id = ?",user_id)
  slim(:"items",locals:{item:result})
end

def new_item(id, user_id)
  item = params[:item]
  damage = params[:damage].to_i
  db_connection().execute("INSERT INTO items (name,damage,user_id) VALUES (?,?,?)",item,damage,id).first
end

def edit_item(id, item)
  db_connection().execute("UPDATE items SET name=? WHERE id=?",item,id).first
end

def edit_item_damage(id, damage)
  db_connection().execute("UPDATE items SET damage=? WHERE id=?",damage,id).first
end

def delete_item(id)
  db_connection().execute("DELETE FROM items WHERE id = ?",id)
end