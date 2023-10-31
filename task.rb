#Бережний Дмитро КС31
#Шліхутка Іван КС31
require 'set'

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
    "From " + @from.to_s + " To " + @to.to_s + " Weight " + @weight.to_s
  end
end

class GraphSubset
  attr_accessor :parent, :rank

  def initialize
    @parent = self
    @rank = 0
  end
end

def kruskal(vertices, edges_array)
  edges_array.sort_by! { |edge| edge.weight }

  minimum_spanning_tree = []
  graph_subsets = Array.new(vertices) {
    GraphSubset.new
  }

  edges_array.each do |edge|

    from_point_set = find_set(graph_subsets[edge.from])
    to_point_set = find_set(graph_subsets[edge.to])

    if from_point_set != to_point_set
      minimum_spanning_tree << edge
      union_sets(from_point_set, to_point_set)
    end
  end

  minimum_spanning_tree
end

def find_set(node)
  node.parent
end

def union_sets(first_set, second_set)
  if first_set.rank > second_set.rank
    second_set.parent = first_set
  else
    first_set.parent = second_set
    if first_set.rank == second_set.rank
      second_set.rank += 1
    end
  end
end

###### Приклад виконання
puts "Введіть максимальну кількість вершин (vertices):"
vertices = gets.chomp.to_i

while vertices <= 0 || vertices > 100
  puts "Введено некоректну кількість точок. Спробуйте знову."
  puts "Введіть кількість вершин (vertices):"
  vertices = gets.chomp.to_i
end

counter = 0
edges_set = Set.new

loop do
  puts "Введіть ребро #{counter} у форматі 'vertex_from vertex_to weight' для кожного ребра (наприклад, '1 2 5') або 'end' для завершення:"
  input = gets.chomp

  break if input.downcase == 'end'

  values = input.split.map(&:to_i).take(3)
  while values.size != 3 || values.any? { |vertex| vertex < 0 } || values[0, 2].any? { |vertex| vertex >= vertices }
    puts "Введено некоректне ребро. Спробуйте знову."
    input = gets.chomp
    break if input.downcase == 'end'
    values = input.split.map(&:to_i).take(3)
  end

  break if input.downcase == 'end'

  from, to, weight = values
  edge = Edge.new(from, to, weight)

  if edges_set.include?(edge)
    puts "Ребро вже присутнє в множині."
  else
    edges_set << edge
    counter += 1
  end
end

puts "Ребра:"
edges_set.each_with_index do |edge, index|
  puts "Ребро #{index}: from #{edge.from} to #{edge.to}, вага #{edge.weight}"
end

minimum_spanning_tree = kruskal(vertices, edges_set.to_a)

puts "\nMinimum Spanning Tree:\n"
minimum_spanning_tree.each do |edge|
  puts "Edge: #{edge.from} - #{edge.to}, Weight: #{edge.weight}"
end
