class AddUniquenessToAcceptance < ActiveRecord::Migration
  def change
    add_index :acceptances, [:person_id, :purchase_id], :unique => true
  end
end
