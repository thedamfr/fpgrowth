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
    end
  end
end
