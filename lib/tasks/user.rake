task :mkuser=>:environment do |t|
  u = User.new
  u.login='mml'
  u.change_password 'standard'
  u.firstname='McClain'
  u.lastname='Looney'
  u.verified=1
  u.email='m@loonsoft.com'
  u.save!
end
