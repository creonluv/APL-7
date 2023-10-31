class Edge
  attr_accessor :from, :to, :weight

  def initialize(from, to, weight)
    @from = from
    @to = to
    @weight = weight
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

def kruskal(vertices, edges)
  edges.sort_by! { |edge|
    edge.weight
  }
  puts edges
  puts

  minimum_spanning_tree = []

  disjoint_sets = Array.new(vertices) {
    DisjointSet.new
  }

  edges.each do |edge|
    point_from_set = find_set(disjoint_sets[edge.from])
    puts "from_set === " + point_from_set.to_s
    point_to_set = find_set(disjoint_sets[edge.to])
    puts "to_set === " + point_to_set.to_s

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

def union_sets(a, b)
  puts "union!"
  if a.rank > b.rank
    b.parent = a
  else
    a.parent = b
    if a.rank == b.rank
      b.rank += 1
    end
  end
  #------------------
  # if b.rank > a.rank
  #   a.parent = b
  #   return
  # end
  # b.parent = a
  # if a.rank == b.rank
  #   a.rank+=1
  # end
end

# Приклад використання
puts "Введіть кількість вершин (vertices):"
vertices = gets.chomp.to_i
# vertices = 15
# edges = [Edge.new(1, 2, 1),
#          Edge.new(3, 1, 4)]
edges = [Edge.new(0, 1, 3),
         Edge.new(0, 2, 5),
         Edge.new(1, 2, 2),
         Edge.new(1, 3, 1),
         Edge.new(2, 3, 1),
         Edge.new(3, 4, 3),
         Edge.new(4, 1, 2)]

minimum_spanning_tree = kruskal(vertices, edges)

puts "Minimum Spanning Tree:"
minimum_spanning_tree.each do |edge|
  puts "Edge: #{edge.from} - #{edge.to}, Weight: #{edge.weight}"
end
