require 'set'
module FpGrowth
  module FpTree
    class HeaderTable

      def self.build(item, header_table)
        builder = Builder::HeaderTableBuilder.new(item, header_table)
        return builder.execute()
      end


      def initialize()
        @count = Hash.new 0
        @nodes = Hash.new { Set.new() }
      end

      attr_accessor :count, :nodes

      def keys
        @nodes.keys
      end

      # Append a Row
      # @param row Array as  [item, support, node]
      #
      def << (row)
        # Add a link for m in HeaderTable
        puts "pour #{row[0]}"
        puts "avant " + @nodes[row[0]].to_s
        @nodes[row[0]] = @nodes[row[0]] << row[2]
        puts "apres " + @nodes[row[0]].to_s
        # Add support m = previous + n
        @count[row[0]] += row[1]
      end

    end
  end
end

class Set
  def to_s
    to_a.join(', ')
  end
end