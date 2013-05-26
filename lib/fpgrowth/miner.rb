require_relative 'fp_tree'
require_relative 'miner/conditional_tree_builder'

module FpGrowth
  module Miner
    class Miner
      def build_conditionnal_tree(tree=FpTree.new, pattern)
        ConditonnalTreeBuilder.new().execute(tree, pattern)
      end
    end
  end
end
