class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :text

      t.timestamps
    end
  end
end
