require "bigdecimal"

module AmountMultiplier
  def amount
    BigDecimal.new(read_attribute(:amount) || 0)/100
  end

  def amount=(value)
    write_attribute(:amount, (BigDecimal.new(value)*100).to_i)
  end
end
