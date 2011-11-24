class AddGravatarEmailToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string :gravatar_email
    end

    User.all.each do |user|
      user.gravatar_email = user.email
      user.save
    end
  end

  def down
    change_table :users do |t|
      t.remove :gravatar_email
    end
  end
end
