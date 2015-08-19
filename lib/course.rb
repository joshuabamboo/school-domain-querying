class Course

  attr_accessor :id, :name, :department_id

  def self.create_table
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS courses (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, department_id INTEGER)
    SQL

    DB[:conn].execute(sql)
    
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS courses"
    DB[:conn].execute(sql)
  end

  def self.new_from_db(row)
    new.tap do |instance|
      instance.id = row[0]
      instance.name = row[1]
    end

  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM courses WHERE name = ?
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.find_all_by_department_id(department_id)
    sql = <<-SQL
      SELECT * FROM courses WHERE department_id = ?
    SQL
    results = DB[:conn].execute(sql, department_id)
    results.map { |row| self.new_from_db(row) }
  end

  def insert
    sql = <<-SQL
      INSERT INTO courses(name, department_id)
      VALUES(?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.department_id)
    sql = <<-SQL
      SELECT id FROM courses WHERE(name = ?)
      SQL
    database_id = DB[:conn].execute(sql, self.name)
    @id=(database_id).flatten.first  

  end


end