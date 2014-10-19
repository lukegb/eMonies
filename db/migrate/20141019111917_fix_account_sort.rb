class FixAccountSort < ActiveRecord::Migration
  def change
    change_table :people do |t|
      t.change :account_number, :string
      t.change :sort_code, :string
    end
  end
end
