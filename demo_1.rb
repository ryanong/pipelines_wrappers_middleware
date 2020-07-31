LineItem = Struct.new(:description, :category, :amount)

line_items = [
  LineItem.new('Across the Universe', :movie, 100),
  LineItem.new('Tobe Nwigwe - MAKE IT HOME', :song, 100),
]

calculate_total = ->(line_items) do
  line_items.sum(&:amount)
end

total = calculate_total.(line_items)

puts total
