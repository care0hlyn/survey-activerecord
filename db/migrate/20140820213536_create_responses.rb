class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.column :text, :string
      t.belongs_to :user
      t.belongs_to :survey
      t.belongs_to :answer
      t.belongs_to :question
      t.timestamps
    end
  end
end
