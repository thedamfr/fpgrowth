require_relative 'fp_tree'
require_relative 'miner/pattern_base_extractor'
require_relative 'miner/conditional_tree_builder'

module FpGrowth
  module Miner
    def self.build_conditional_tree(tree=FpTree.new, item)
      pattern_base = PatternBaseExtractor.new(tree, item).execute()
      pattern_base.each { |x| puts x.content.to_s}
      tree = ConditionalTreeBuilder.new(pattern_base, tree.threshold).execute()
    end
  end
end
