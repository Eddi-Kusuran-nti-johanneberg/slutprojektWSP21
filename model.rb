require 'sqlite3'
require 'bcrypt'

module Model

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

def validate_user_for_characters(params)
  id = params[:id].to_i
  user_id = session[:id]
  user = db_connection().execute("SELECT user_id FROM characters WHERE id = ?", id)[0][0]
  if user_id == user
    return true
  else
    return false
  end
end

def validate_user_for_items(params)
  id = params[:id].to_i
  user_id = session[:id]
  users = db_connection().execute("SELECT user_id FROM items WHERE id = ?", id)[0][0]
  if user_id == user
    return true
  else
    return false
  end
end

def get_characters_for_user(user_id)
  result = db_connection().execute("SELECT * FROM characters WHERE user_id = ?",user_id)
end

def get_items_for_characters(user_id)
  result = db_connection().execute("SELECT * FROM items WHERE user_id = ?",user_id)
end

def get_item_from_character_name(name)
  char_id = db_connection().execute("SELECT id FROM characters WHERE name = ?", name)[0]["id"]
  item_id = db_connection().execute("SELECT item_id FROM characters_items_relations WHERE char_id = ?", char_id)[0]["item_id"]
  result = db_connection().execute("SELECT name FROM items WHERE id = ?", item_id)
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
  char_id = db_connection().execute("SELECT id FROM characters WHERE name = ?", character)[0]["id"]
  item_id = params[:item]
  db_connection().execute("INSERT INTO characters_items_relations (char_id, item_id) VALUES (?,?)", char_id, item_id)
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
  db_connection().execute("UPDATE characters SET name = ?, strength = ?, intelligence = ?, willpower = ?, agility = ?, speed = ?, endurance = ?, personality = ?, luck = ? WHERE id = ?",character,strength,intelligence,willpower,agility,speed,endurance,personality,luck,id).first
  char_id = db_connection().execute("SELECT id FROM characters WHERE name = ?", character)[0]["id"]
  item_id = params[:item]
  db_connection().execute("UPDATE characters_items_relations SET item_id = ? WHERE char_id = ?", item_id, char_id)
end

def delete_character(id)
  db_connection().execute("DELETE FROM characters WHERE id = ?",id)
end

def get_items_for_user(user_id)
  id = session[:id].to_s
  result = db_connection().execute("SELECT * FROM items WHERE user_id = ?",user_id)
end

def new_item(id, user_id)
  item = params[:item]
  damage = params[:damage].to_i
  db_connection().execute("INSERT INTO items (name,damage,user_id) VALUES (?,?,?)",item,damage,id).first
end

def edit_item(id, item)
  db_connection().execute("UPDATE items SET name = ? WHERE id = ?",item,id).first
end

def edit_item_damage(id, damage)
  db_connection().execute("UPDATE items SET damage = ? WHERE id = ?",damage,id).first
end

def delete_item(id)
  db_connection().execute("DELETE FROM items WHERE id = ?",id)
end

end