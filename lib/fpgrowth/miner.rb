require_relative 'fp_tree'
require_relative 'miner/conditional_tree_builder'

module FpGrowth
  module Miner
    class Miner
      def build_conditional_tree(tree=FpTree.new, pattern)
        ConditonalTreeBuilder.new(tree, pattern).execute()
      end
    end
  end
end
