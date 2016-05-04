class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      #AuthLogic
      t.string    :login,               :null => false                # optional, you can use email instead, or both
      t.string    :email,               :null => false                # optional, you can use login instead, or both
      t.string    :crypted_password,    :null => false                # optional, see below
      t.string    :password_salt,       :null => false                # optional, but highly recommended
      t.string    :persistence_token,   :null => false                # required
      #t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability
        
      # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
      t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns
      
      
      #APPLICATION SPECIFICS
      t.references  :role,                  :null => false, :default => 5 #Salesman
      t.references  :status,                :null => false, :default => 1
      t.string      :alias,                 :null => false  #instead names
      t.references  :location,              :null => false, :default => 1
      t.string      :phone
      t.string      :mobile                  
      t.datetime    :password_last_set_on,  :null => false
      t.string      :ip_address
      t.timestamps
    end
    
    add_index :users, [:perishable_token]
    add_index :users, [:location_id]
    add_index :users, [:role_id]
    add_index :users, [:status_id]
    
    
    User.new({
      'id' => 1,
      'login' => 'b.radev',
      'email' => 'b.radev@gmail.com',
      'password' => 'qwerty123', #Temporary initial password
      'password_confirmation' => 'qwerty123',
      'role_id' => 1,
      'status_id' => 1,
      'alias' => 'Борислав Радев',
      'location_id' => 1,
      'phone' => '0888939489',
      'mobile' => '0888939489',
      'password_last_set_on' => Time.now.to_s(:db)
    }).save!
    
  end

  def self.down
    remove_index :users, [:perishable_token]
    remove_index :users, [:location_id]
    remove_index :users, [:role_id]
    remove_index :users, [:status_id]
    drop_table :users
  end
end