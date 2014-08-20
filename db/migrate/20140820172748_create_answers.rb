class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.column :text, :string
      t.belongs_to :questions
      t.timestamps
    end
  end
end
