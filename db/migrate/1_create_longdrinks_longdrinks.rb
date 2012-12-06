class CreateLongdrinksLongdrinks < ActiveRecord::Migration

  def up
    create_table :refinery_longdrinks do |t|
      t.string :title
      t.text :command
      t.datetime :started
      t.datetime :finished
      t.text :problems
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-longdrinks"})
    end

    drop_table :refinery_longdrinks

  end

end
