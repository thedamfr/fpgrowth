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
            traverse_from_node_top_top(node)
          end
        end

        def traverse_from_node_top_top(node)
          if node.item != nil
            # For each node m
            @new_header_table << node
            traverse_from_node_top_top(node.parent)
          end
        end

      end
    end
  end
end
