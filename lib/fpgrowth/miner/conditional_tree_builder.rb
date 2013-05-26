require_relative '../fp_tree'

module FpGrowth
  module Miner
    class ConditionalTreeBuilder

      def initialize(tree=FpTree.new, pattern)
        @tree = tree
        @conditional_tree = FpTree::FpTree.new(tree.supports)
        @supports = {}
        @horizontal_cursor = tree.heads[pattern]
        @pattern = pattern
      end


      def execute()
        case @pattern
          when Array
            return ConditionalTreeBuilder.new(ConditionalTreeBuilder.new(tree, @pattern[0]).execute,
                                              @pattern[1..-1]).execute
          else
            horizontal_traversal()
        end
      end

      # Method accountable of horizontal tree traversal
      #
      def horizontal_traversal(horizontal_cursor=@horizontal_cursor)
        @horizontal_cursor=horizontal_cursor
        while @horizontal_cursor != nil
          horizontal_traversal_step()
          @horizontal_cursor = @horizontal_cursor.lateral
        end
      end

      # Method accountable of treating each branch
      #
      # Make a copy of the pattern branch and append it to tree
      #
      # To achieve it, it make a list of the upper nodes
      # Then it make a branch with it by chaining each element in the node
      # finally, lower part of the pattern_branch is deeply cloned and appended to the current branch
      #
      def horizontal_traversal_step(horizontal_cursor=@horizontal_cursor)
        @min_support = horizontal_cursor.support
        @current_branch = []
        @vertical_cursor = horizontal_cursor.parent
        @current_branch = down_to_top_traversal()
        @current_branch_root = chain_branch()
        @current_branch.last.children += horizontal_cursor.clone_tail_deep()
        append_branch_to_tree(@current_branch_root)
      end

      # Method accountable of appending a branch to the tree
      #
      # Recursively append each node to the tree
      #
      def append_branch_to_tree(cursor, tree=@conditional_tree)
        if cursor.parent
          tree.append_node(cursor.parent, cursor)
        else
          tree.append_node(tree.root, cursor)
        end
        for child in children
          append_branch_to_tree(child)
        end
      end

      # Method accountable of making a branch with the array
      #
      def chain_branch(current_branch=@current_branch)
        @current_branch_root = current_branch.first
        for i in (1..current_branch.size)
          current_branch[i-1].children << current_branch[i]
        end
        return @current_branch_root
      end

      # Method accountable of reading the upper part of the branch
      #
      # Each step, it makes a new node with the same item, but with minimum support
      # Then the new node is added to a list
      # Finally, the list is reversed
      #
      def down_to_top_traversal(current_branch=@current_branch, vertical_cursor=@vertical_cursor)
        while vertical_cursor != nil
          down_to_top_traversal_step()
          vertical_cursor = vertical_cursor.parent
        end
        current_branch.reverse!
      end

      # Method wich represent a step of the vertical down_to_top_traversal
      #
      # It make the new node, with the minimum support
      #
      def down_to_top_traversal_step(current_branch=@current_branch, vertical_cursor=@vertical_cursor, min_support=@min_support)
        current_branch << FpGrowth::FpTree::Node.new(vertical_cursor.item, min_support)
      end


    end
  end
end
