require 'fpgrowth/fptree/fp_tree'
require 'fpgrowth/fptree/node'
module FpGrowth
  module FpTree
    module Builder
      class SecondPass

        attr_accessor :fp_tree

        def initialize(supports)
          @fp_tree = FpTree.new(supports)
        end

        def execute(transactions)
          @fp_tree = FpTree.new
          for transaction in transactions
            transaction = sort_transaction(transaction)
            #Look for leaf
            traverse(@fp_tree.root, transaction)

          end
        end

        def sort_by_support(transaction)
          lookup = @fp_tree.item_order_lookup

          transaction = transaction.sort_by do |item|
            lookup.fetch(item, lookup.size + 1)
          end
          return transaction
        end

        def traverse(cursor_tree, transaction)
          found = false
          i = 0
          while found == false and i < cursor_tree.children.size
            if cursor_tree.children[i].item == transaction[0] then
              continue_pattern(cursor_tree.children[i], transaction[0..transaction.size])
              found = true
            end
            i+=1
          end
          fork_pattern(cursor_tree, transaction) if found == false
        end

        def fork_pattern(cursor_tree, transaction)
          for item in transaction.items
            node = Node.new(item, 1)
            append_node(cursor_tree, node)
            cursor_tree = node
          end
        end

        def append_node(cursor_tree, node)
          cursor_tree.children << node
          sort_by_support(cursor_tree.children)
          @fp_tree.find_lateral_leaf_for_item(node.item).lateral = node
        end

        def continue_pattern(cursor_tree, transaction)
          cursor_tree.support+=1
          traverse(cursor_tree, transaction[1..transaction.size])
        end

      end
    end
  end
end
