class RemoveOldstyleColumnFromBeers < ActiveRecord::Migration
  def change
		remove_column :beers, :oldstyle_, :string
  end
end
