require_relative '../fp_tree'
require 'fpgrowth/fp_tree'

module FpGrowth
  module Miner
    class PatternBaseExtractor

      def initialize(tree=FpTree::FpTree.new() , item)
        @tree = tree
        @horizontal_cursor = tree.heads[item]
        @conditional_item = item
        @patterns=[]
      end

      def execute()
        horizontal_traversal()
        return @patterns
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
      # Make a copy of the item branch and append it to tree
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
        @vertical_cursor = vertical_cursor
        while @vertical_cursor != nil and @vertical_cursor.item != nil
          down_to_top_traversal_step(current_branch)
          @vertical_cursor = @vertical_cursor.parent
        end
        current_branch.reverse!
      end

      # Method wich represent a step of the vertical down_to_top_traversal
      #
      # It just gather items
      #
      def down_to_top_traversal_step(current_branch=@current_branch, vertical_cursor=@vertical_cursor)
        current_branch << vertical_cursor.item
      end


      #fonction qui sert uniquement pour les tests
      def test_conditionnal_item(item )
        if   item == @conditional_item
        then  return true
        end
        return false
      end

      def test_patterns(patterns = [])
        if  patterns == @patterns
        then  return true
        end
        return false
      end

      def test_tree(tree = FpTree::FpTree.new() )
        if  tree.threshold == @tree.threshold and tree.root == @tree.root
        then  return true
        end
        return false
      end

      def test_min_support( min_support )
        if  min_support == @min_support
        then  return true
        end
        return false
      end

      def test_current_branch (current_branch)
        if current_branch  == @current_branch
        then  return true
        end
        return false
      end

      def vertical_cursor (vertical_cursor)
        if vertical_cursor  == @vertical_cursor
        then  return true
        end
        return false
      end




    end
  end
end
