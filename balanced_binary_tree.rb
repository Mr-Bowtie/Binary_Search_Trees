require 'pry'

class Node
  include Comparable
  attr_accessor :data, :left, :right

  def <=>(other)
    data <=> other.data
  end

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :starting_array

  def initialize(starting_array)
    @starting_array = starting_array
    @root = build_tree(starting_array)
  end

  def build_tree(array)
    return nil if array.empty?

    sorted_array = array.uniq.sort
    mid = sorted_array.index(sorted_array[-1]) / 2
    mid_element = sorted_array.delete_at(mid)
    root = Node.new(mid_element)

    root.left = build_tree(sorted_array[0...mid])
    root.right = build_tree(sorted_array[mid..-1])

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

best_tree = Tree.new([4, 3, 7, 8, 2, 9, 9, 0])
best_tree.pretty_print
