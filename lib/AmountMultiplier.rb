module AmountMultiplier
  def amount
    (read_attribute(:amount) || 0)/100.to_f
  end

  def amount=(value)
    write_attribute(:amount, (value.to_f*100).to_i)
  end
end
