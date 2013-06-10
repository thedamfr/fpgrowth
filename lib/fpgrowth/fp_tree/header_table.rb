module FpGrowth
  module FpTree
    class HeaderTable

      def self.build(item, header_table)
        builder = Builder::HeaderTableBuilder.new(item, header_table)
        return builder.execute()
      end


      def initialize()
        @count = Hash.new 0
        @nodes = Hash.new Array.new
      end

      attr_accessor :count, :nodes

      def keys
        @nodes.keys
      end

      def << (y)
        # Add a link for m in HeaderTable
        @nodes[y.item] << item
        # Add support m = previous + n
        @count[y.item] += y.suppport
      end

    end
  end
end
