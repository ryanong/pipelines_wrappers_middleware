require "pry"
LineItem = Struct.new(:description, :category, :amount)

line_items = [
  LineItem.new('Across the Universe', :movie, 100),
  LineItem.new('Tobe Nwigwe - MAKE IT HOME', :song, 100),
]

calculate_total = ->(line_items) do
  line_items.sum(&:amount)
end

add_taxes = ->(line_items) do
  puts "add taxes"
  line_items + [
    LineItem.new('taxes', :taxes, calculate_total.(line_items) * 0.1)
  ]
end

add_discount = ->(category, percent, line_items) do
  puts "add discount"
  discount_total = line_items.
    select { |line_item| line_item.category == category }.
    then(&calculate_total) * (percent / 100.0)

  line_items + [
    LineItem.new('discount', :discount, -discount_total)
  ]
end

pay_with_credit_card = ->(line_items) do
  puts "pay with credit card"
  line_items + [
    LineItem.new('credit card', :credit_card, calculate_total.(line_items))
  ]
end

stock_wrapper = ->(app, line_items) do
  #hold_stock(line_items)
  puts "hold stock"
  total = app.call(line_items)

  if total == 0
    #take_stock(line_items)
    puts "take stock"
  else
    #return_stock(line_items)
    puts "return stock"
  end

  total
end

stack = [stock_wrapper.curry]

step_to_middleware = ->(current_step, next_step, line_items) do
  next_line_items = current_step.call(line_items)
  next_step.call(next_line_items)
end

[
  add_discount.curry.call(:song, 50),
  add_taxes,
  pay_with_credit_card,
  calculate_total
].each do |step|
  stack << step_to_middleware.curry.call(step)
end

app = stack.inject(->(result) { result } ) do |next_middleware, current_middleware|
  next_middleware.call(current_middleware)
end

# I COULDN'T GET IT TO WORK. USE AN EXISTING PACKAGE
total = app.call(calculate_total, line_items)

puts total
