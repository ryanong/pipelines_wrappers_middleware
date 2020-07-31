LineItem = Struct.new(:description, :category, :amount)

line_items = [
  LineItem.new('Across the Universe', :movie, 100),
  LineItem.new('Tobe Nwigwe - MAKE IT HOME', :song, 100),
]

calculate_total = ->(line_items) do
  line_items.sum(&:amount)
end

add_taxes = ->(line_items) do
  line_items + [
    LineItem.new('taxes', :taxes, calculate_total.(line_items) * 0.1)
  ]
end

add_discount = ->(category, percent, line_items) do
  discount_total = line_items.
    select { |line_item| line_item.category == category }.
    then(&calculate_total) * (percent / 100.0)

  line_items + [
    LineItem.new('discount', :discount, -discount_total)
  ]
end

pay_with_credit_card = ->(line_items) do
  line_items + [
    LineItem.new('credit card', :credit_card, -calculate_total.(line_items))
  ]
end

stock_wrapper = ->(line_items) do
  puts "hold stock"
  total = line_items.
    then(&add_discount.curry.call(:song, 50)).
    then(&add_taxes).
    then(&pay_with_credit_card).
    then(&calculate_total)

  if total == 0
    puts "take stock"
  else
    puts "return stock"
  end

  total
end

total = stock_wrapper.(line_items)
puts total
