
require_relative 'database_connection'

class User
  attr_reader :id, :username
  
  def initialize(id, username)
    @id = id
    @username = username
  end

  def self.create_user(username:, password:)
    users = DatabaseConnection.query("SELECT username FROM users;")
    if users[0]['username'].include? username
      false 
    else
      DatabaseConnection.query("INSERT INTO users (username, password) VALUES ('#{username}', '#{password}');")
      true
    end
  end

  def self.check_login(username:, password:)
    users = DatabaseConnection.query("SELECT username FROM users;")
    if users[0]['username'].include? username
      result = DatabaseConnection.query("SELECT password FROM users WHERE username LIKE '#{username}';")
      if result[0]['password'] == password
        true
      else
        false
      end
    else 
      false
    end 
  end

end