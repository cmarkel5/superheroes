require 'pg'

class SuperheroesConnection

def initialize
    @conn = PG.connect(:dbname =>'superheroes', :host => 'localhost')
    @conn.prepare("insert_superhero", "INSERT INTO superheroes (name, alter_ego, has_cape, power, arch_nemesis) VALUES ($1, $2, $3, $4, $5)")
  end

  def delete_all
    @conn.exec( "DELETE FROM superheroes" )
  end

  def insert_superhero(name, alter_ego, has_cape, power, arch_nemesis)
    @conn.exec_prepared("insert_superhero", [name, alter_ego, has_cape, power, arch_nemesis])
  end

  def print_superheroes
    @conn.exec( "SELECT * FROM superheroes ORDER BY name" ) do |result|
      result.each do |row|
        #puts row
        puts "#{row['name']}'s superpower is #{row['power']}."
      end
    end
  end

  def close
    @conn.close
  end
end

begin
 
  connection = SuperheroesConnection.new

  connection.delete_all

  connection.insert_superhero('Superman', 'Clark Kent', 'true', 'flies', 'Lex Luther')
  connection.insert_superhero('Spiderman', 'Peter Parker', 'false', 'web shooter', 'Green Goblin')
  connection.insert_superhero('Batman', 'Bruce Wayne', 'true', 'none', 'Joker')
  connection.insert_superhero('Wolverine', 'Logan', 'false', 'steel claws', 'Magneto')

  connection.print_superheroes
rescue Exception => e
    puts e.message
    puts e.backtrace.inspect
ensure
  connection.close
end
