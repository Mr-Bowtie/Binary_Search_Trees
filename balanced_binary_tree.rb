require 'pry'

class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def child_num
    if left != nil && right != nil
      2
    elsif left != nil || right != nil
      1
    else
      0
    end
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

  def insert(value, node = @root)
    return @root = Node.new(value) unless @root

    if node.data == value
      return nil
    elsif node.data < value
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    else
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    end
  end

  def delete(value, node = @root)
    return node if node.nil?

    if value > node.data
      node.right = delete(value, node.right)
    elsif value < node.data
      node.left = delete(value, node.left)
    else
      # handles case of 1 or 0 children
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      # if node has 2 childen: find the next largest node
      successor = inorder_successor(node)
      # copy successor value to the current node
      node.data = successor.data
      # delete it from the branch to the right ( to avoid deleting the current node )
      delete(successor.data, node.right)
    end
    node
  end

  def inorder_successor(node = @root)
    return nil if node.child_num.zero?
    node = node.right
    return node if node.left.nil?
    until node.child_num.zero?
      node = node.left
    end
    node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

best_tree = Tree.new([1, 4, 3, 7, 8, 2, 9, 6, 5])
best_tree.pretty_print
best_tree.delete(5)
best_tree.pretty_print
