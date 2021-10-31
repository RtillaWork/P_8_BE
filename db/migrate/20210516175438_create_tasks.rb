class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :kind
      t.boolean :is_published, :default => true
      t.datetime :unpublished_at, :default => nil
      t.boolean :is_fullfilled, :default => false
      t.float :lat, :default => 0.1
      t.float :lng, :default => 0.1
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
