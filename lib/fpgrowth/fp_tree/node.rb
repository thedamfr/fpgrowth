module FpGrowth
  module FpTree
    class Node
      attr_accessor :item, :support, :children, :lateral, :parent

      def initialize(item=nil, support=1)
        @item = item
        @support = support
        @children = []
        @lateral = nil
        @parent = nil
      end

      # Clone childrens, deeply
      #
      def clone_tail_deep
        cloned_tail = []
        for child in children
          cloned_tail << child.clone_deep()
        end
        return cloned_tail
      end

      # Clone Node, deeply
      # Must ignore parent and lateral, which are relative to this node in his tree, not to the clone
      #
      def clone_deep
        clone = Node.new()
        clone.item = @item
        clone.support = @support
        clone.children = clone_tail_deep()
        return clone
      end

      def ==(other_object)
        return false unless other_object
        flag = true
        flag = false if @item != other_object.item
        flag = false if @support != other_object.support
        flag = false if @children != other_object.children
        return flag
      end

      def to_s
        "<Node item=#{@item} support=#{@support}>"
      end

    end
  end
end
