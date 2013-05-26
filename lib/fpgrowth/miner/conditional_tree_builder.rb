require_relative '../fp_tree'
require_relative 'pattern'
require 'fpgrowth/fp_tree'

module FpGrowth
  module Miner
    class ConditionalTreeBuilder

      def initialize(tree=FpTree.new, pattern)
        @tree = tree
        @horizontal_cursor = tree.heads[pattern]
        @conditional_pattern = pattern
        @patterns=[]
      end


      def execute()
        case @conditional_pattern
          when Array
            return ConditionalTreeBuilder.new(ConditionalTreeBuilder.new(tree, @conditional_pattern[0]).execute,
                                              @conditional_pattern[1..-1]).execute
          else
            horizontal_traversal()
        end
        return FpTree.build(make_transactions())
      end

      def make_transactions(patterns=@patterns)
        transactions = []
        for pattern in patterns
          for i in (1..pattern.support)
            transactions << pattern.content.clone
          end
        end
        return transactions
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
      # Then build a Pattern
      #
      def horizontal_traversal_step(horizontal_cursor=@horizontal_cursor)
        @min_support = horizontal_cursor.support
        @current_branch = []
        @vertical_cursor = horizontal_cursor.parent
        @current_branch = down_to_top_traversal()
        @patterns << Pattern.new(@current_branch, @min_support)
      end


      # Method accountable of reading the upper part of the branch
      #
      # Each step, it makes a new node with the same item, but with minimum support
      # Then the new node is added to a list
      # Finally, the list is reversed
      #
      def down_to_top_traversal(current_branch=@current_branch, vertical_cursor=@vertical_cursor)
        while vertical_cursor != nil and vertical_cursor.item != nil
          down_to_top_traversal_step()
          vertical_cursor = vertical_cursor.parent
        end
        current_branch.reverse!
      end

      # Method wich represent a step of the vertical down_to_top_traversal
      #
      # It just gather items
      #
      def down_to_top_traversal_step(current_branch=@current_branch, vertical_cursor=@vertical_cursor, min_support=@min_support)
        current_branch << vertical_cursor.item
      end
    end
  end
end
