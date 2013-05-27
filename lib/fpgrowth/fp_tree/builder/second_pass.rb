require 'fpgrowth/fp_tree'
module FpGrowth
  module FpTree
    module Builder
      class SecondPass

        attr_accessor :fp_tree

        def initialize(supports, threshold=1)
          @supports = supports
          @fp_tree = FpTree.new(supports, threshold)
        end

        def execute(transactions)
          @fp_tree = FpTree.new(@supports)
          for transaction in transactions
            transaction = sort_by_support(transaction)
            #Look for leaf
            traverse(@fp_tree.root, transaction)

          end
          return @fp_tree
        end

        def sort_by_support(transaction)
          lookup = @fp_tree.item_order_lookup

          transaction.sort_by! do |item|
            lookup.fetch(item, lookup.size + 1)
          end
        end



        def traverse(cursor_tree, transaction)
          if transaction and transaction.size > 0
            found = false
            if cursor_tree.item == transaction.first
              continue_pattern(cursor_tree, transaction)
              found = true
            end
            i = 0
            while found == false and i < cursor_tree.children.size
              if cursor_tree.children[i].item == transaction[0] then
                continue_pattern(cursor_tree.children[i], transaction)
                found = true
              end
              i+=1
            end
            fork_pattern(cursor_tree, transaction) unless found
          end
        end

        def fork_pattern(cursor_tree, transaction)
          node = Node.new(transaction.first, 1)
          @fp_tree.append_node(cursor_tree, node)
          cursor_tree = node
          traverse(cursor_tree, transaction[1..transaction.size])
        end


        def continue_pattern(cursor_tree, transaction)
          cursor_tree.support+=1
          traverse(cursor_tree, transaction[1..transaction.size])
        end

      end
    end
  end
end
