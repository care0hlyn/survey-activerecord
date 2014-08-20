class CreateSurvey < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.column :name, :string
      t.column :topic, :string

      t.timestamps
    end
  end
end
