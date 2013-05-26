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
      end

      # Clone Node, deeply
      # Must ignore parent and lateral, which are relative to this node in his tree, not to the clone
      #
      def clone_deep
        clone = Node.new()
        clone.item = @item
        clone.support = @support
        clone.children = clone_tail_deep()
      end

    end
  end
end
