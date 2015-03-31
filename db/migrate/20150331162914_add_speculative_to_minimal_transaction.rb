class AddSpeculativeToMinimalTransaction < ActiveRecord::Migration
  def change
    add_column :minimal_transactions, :speculative, :boolean, default: false
  end
end
