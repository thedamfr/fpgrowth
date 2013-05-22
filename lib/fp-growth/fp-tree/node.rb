module FpGrowth
  module FpTree
    class Node
      attr_accessor :item, :support, :children, :lateral
      def initialize(item=nil, support=1)
        @item = item
        @support = support
        @children = []
        @lateral = nil
      end
    end
  end
end
