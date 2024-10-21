class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :status
      t.string :url
      t.json :result

      t.timestamps
    end
  end
end
