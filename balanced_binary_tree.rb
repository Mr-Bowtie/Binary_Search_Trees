class Node
  include Comparable
  attr_accessor :data, :left_child, :right_child

  def <=>(other)
    data <=> other.data
  end

  def initialize(data)
    @data = data
    @left_child = nil
    @right_child = nil
  end
end

class Tree
  attr_reader :array
  attr_accessor :root

  def initialize(array)
    @array = array
    @root = nil
  end
end
