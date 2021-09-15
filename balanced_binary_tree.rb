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

  def find(value, node = @root)
    return node if node.data == value

    if value < node.data
      find(value, node.left)
    else
      find(value, node.right)
    end
  end

  # #iterative solution
  # def level_order
  #   current_node = @root
  #   queue = [] << current_node
  #   tree_values = []
  #   until queue.empty?
  #     queue << current_node.left unless current_node.left.nil?
  #     queue << current_node.right unless current_node.right.nil?

  #     tree_values << queue.shift.data
  #     current_node = queue[0]
  #   end
  #   tree_values
  # end

  # recursive solution
  def level_order(node = @root, queue = [@root], values = [])
    queue << node.left unless node.left.nil?
    queue << node.right unless node.right.nil?

    values << queue.shift.data
    return values if queue.empty?

    level_order(queue[0], queue, values)
  end

  def preorder(node = @root, values = [])
    return values if node.nil?
    values << node.data
    preorder(node.left, values)
    preorder(node.right, values)
  end

  def inorder(node = @root, values = [])
    return values if node.nil?
    inorder(node.left, values)
    puts "Data: #{node.data}"
    puts "Height: #{height(node)}"
    values << node.data
    inorder(node.right, values)
  end

  def postorder(node = @root, values = [])
    return values if node.nil?
    postorder(node.left, values)
    postorder(node.right, values)
    values << node.data
  end

  def height(node)
    return 0 if node.child_num == 0
    left_height = 1 + height(node.left) unless node.left.nil?
    right_height = 1 + height(node.right) unless node.right.nil?
    return left_height if right_height.nil?
    return right_height if left_height.nil?
    left_height > right_height ? left_height : right_height
  end

  def depth(node, root = @root)
    return nil if node.nil?

    if node.data < root.data
      1 + depth(node, root.left)
    elsif node.data > root.data
      1 + depth(node, root.right)
    else
      return 0
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

arr = []
1.upto(20) { |i| arr << i }
best_tree = Tree.new(arr)
best_tree.pretty_print
puts best_tree.depth(best_tree.find(9))
# puts best_tree.depth(best_tree.find(21))
puts best_tree.depth(best_tree.find(10))
puts best_tree.depth(best_tree.find(3))
