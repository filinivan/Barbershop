require 'sqlite3'

db = SQLite3::Database.new 'base.db'
db.results_as_hash = true

db.execute 'select * from Users' do |row|
  print row['username']
  print "\t-\t "
  puts row['date_stamp']
  puts '----------'
end
