class Edge
  attr_accessor :from, :to, :weight

  def initialize(from, to, weight)
    @from = from
    @to = to
    @weight = weight
  end

  def eql?(other)
    @from == other.from && @to == other.to
  end

  def hash
    [@from, @to].hash
  end

  def to_s
    "from " + from.to_s + " to " + to.to_s + " weight " + weight.to_s
  end
end

class DisjointSet
  attr_accessor :parent, :rank

  def initialize
    @parent = self
    @rank = 0
  end

  def to_s
    "rank " + rank.to_s + " parent id " + @id.to_s + "\t".ljust(15) + super.to_s
  end
end

def kruskal(vertices, edges_array)
  edges_array.sort_by! { |edge|
    edge.weight
  }
  puts edges_array
  puts

  minimum_spanning_tree = []

  # disjoint_sets = Array.new(vertices) {
  #   DisjointSet.new
  # }
  disjoint_sets = (0...vertices).each_with_object({}) do |index, map|
    map[index] = DisjointSet.new
  end

  edges_array.each do |edge|
    point_from_set = find_set(disjoint_sets[edge.from])
    # puts "from_set === " + point_from_set.to_s
    point_to_set = find_set(disjoint_sets[edge.to])
    # puts "to_set === " + point_to_set.to_s

    if point_from_set != point_to_set
      minimum_spanning_tree << edge
      union_sets(point_from_set, point_to_set)
    end
  end

  minimum_spanning_tree
end

def find_set(node)
  node.parent
  # puts "this ".ljust(10) + node.to_s
  # if node != node.parent
  #   puts "this parent -> " + node.parent.to_s
  #   node.parent = find_set(node.parent)
  # end
  # node.parent
end

def union_sets(first_set, second_set)
  puts "union!"
  if first_set.rank > second_set.rank
    second_set.parent = first_set
  else
    first_set.parent = second_set
    if first_set.rank == second_set.rank
      second_set.rank += 1
    end
  end
end

# Приклад використання
puts "Введіть кількість вершин (vertices):"

vertices = gets.chomp.to_i
while vertices <= 0 || vertices > 100
  puts "Введено не коректну кількість точок. Спробуйте знову."
  puts "Введіть кількість вершин (vertices):"
  vertices = gets.chomp.to_i
end
# vertices = 3
# edges = [Edge.new(0, 1, 1),
#          Edge.new(2, 0, 4)]

edges_set = Set.new

counter = 0
loop do

  puts "Введіть ребро #{counter} у форматі 'vertex_from vertex_to weight' для кожного ребра (наприклад, '1 2 5') або 'end' для завершення:"
  input = gets.chomp

  break if input.downcase == 'end'

  values = input.split.map(&:to_i).take(3) # Отримання лише перших двох чисел
  while values.size < 3 || values.all? { |vertex| vertex < 0 } || values.take(2).all? { |vertex| vertex >= vertices }
    puts "Введено некоректне ребро. Спробуйте знову."
    puts "Ребро #{counter}: "

    input = gets.chomp
    break if input.downcase == 'end'
    values = input.split.map(&:to_i).take(3)
  end

  from, to = values.take(2) # Беремо тільки перші два числа
  weight = values[2] # Беремо тільки третє число

  edge = Edge.new(from, to, weight)
  if edges_set.include?(edge)
    puts "Ребро вже присутнє в множині."
  else
    edges_set << edge
    counter += 1
  end
end

puts "Результат:"
puts edges_set.size
edges_set.each_with_index do |edge, index|
  puts "Ребро #{index}: from #{edge.from} to #{edge.to}, вага #{edge.weight}"
end

# edges = [Edge.new(0, 1, 3),
#          Edge.new(0, 2, 5),
#          Edge.new(1, 2, 2),
#          Edge.new(1, 3, 1),
#          Edge.new(2, 3, 1),
#          Edge.new(3, 4, 3),
#          Edge.new(4, 1, 2)]

minimum_spanning_tree = kruskal(vertices, edges_set.to_a)

puts "Minimum Spanning Tree:"
minimum_spanning_tree.each do |edge|
  puts "Edge: #{edge.from} - #{edge.to}, Weight: #{edge.weight}"
end
