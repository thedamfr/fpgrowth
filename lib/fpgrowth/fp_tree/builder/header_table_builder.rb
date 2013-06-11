require_relative "../header_table"

module FpGrowth
  module FpTree
    module Builder
      class HeaderTableBuilder


        def initialize(item, header_table)
          @header_table = header_table
          @item = item
          @new_header_table = HeaderTable.new()
        end

        def execute()
          # for each node n in header for item


          for node in @header_table.nodes[@item]
            # traverse tree from n to top
            traverse_from_node_top_top(node.parent, node.support)
          end
          return @new_header_table
        end

        def traverse_from_node_top_top(node, support)
          if node.item
            # For each node m
            @new_header_table << [node.item, support, node]
            traverse_from_node_top_top(node.parent, support)
          end
        end

      end
    end
  end
end
