class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string  :fname
      t.string  :lname
      t.string  :email
      t.string  :name
      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end