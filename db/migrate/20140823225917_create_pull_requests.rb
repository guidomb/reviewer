class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.integer :number
      t.string :title
      t.string :state
      t.string :url
      t.string :sender
      t.string :repository

      t.timestamps
    end
    add_index :pull_requests, [:repository, :number], unique: true
  end
end
