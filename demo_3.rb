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

total = line_items.
  then(&add_taxes).
  then(&calculate_total)

puts total
