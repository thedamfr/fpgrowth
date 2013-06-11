require_relative 'fp_tree'
require_relative 'miner/pattern_base_extractor'
require_relative 'miner/conditional_tree_builder'

module FpGrowth
  module Miner

    def self.build_conditional_tree(tree=FpTree.new, item)
      Miner.new().build_conditional_tree(tree, item)
    end

    def self.fp_growth(fp_tree)
      miner = Miner.new()
      miner.fp_growth(fp_tree)
      return miner.pattern_set
    end

    def self.td_fp_growth(fp_tree)
      miner = Miner.new()
      miner.top_down_fp_growth(fp_tree)
      return miner.pattern_set
    end

    class Miner


      attr_reader :pattern_set

      def initialize
        @pattern_set = []
      end

      def build_conditional_tree(tree=FpTree.new, item)
        pattern_base = PatternBaseExtractor.new(tree, item).execute()
        tree = ConditionalTreeBuilder.new(pattern_base, tree.threshold).execute()
      end


      def fp_growth(fp_tree, pattern_alpha=Pattern.new(), rank=0)
        if fp_tree.single_path?
          # Fin de la récursivité
          for combination in fp_tree.combinations
            # generate pattern_beta U pattern_alpha
            # with support = minimum support of nodes in pattern_beta
            pattern_beta = pattern_alpha.clone
            for node in combination
              pattern_beta << node
            end
            @pattern_set << pattern_beta
            #puts "Pattern extracted : #{pattern_beta.content.to_s} - #{pattern_beta.support}"
          end
        else
          for item in fp_tree.supports.keys
            # generate pattern_beta = item U pattern_alpha with support = item.support
            # construct pattern_beta's conditional pattern base and then pattern_beta's conditionnal FpTree
            pattern_beta = pattern_alpha.clone
            pattern_beta.content << item
            pattern_beta.support= fp_tree.supports[item]
            tree_beta = build_conditional_tree(fp_tree, item)
            fp_growth(tree_beta, pattern_beta, rank + 1) unless tree_beta == nil or tree_beta.empty?
          end
        end
      end

      def top_down_fp_growth(header_table, pattern_alpha=Pattern.new(), min_support=0)

        if header_table.instance_of? FpTree::FpTree
          header_table = header_table.header_table
        end


        # For each row of header_table
        for row in header_table.keys
          # If Support of header_table > min_support
          if header_table.count[row] > min_support then
            # output pattern extended with row.item
            pattern_beta = Pattern.new(pattern_alpha.content + [row], header_table.count[row])
            @pattern_set << pattern_beta
            # puts "Pattern extracted : #{pattern_beta.content.to_s} - #{pattern_beta.support}"
            # Build new Header Table
            header_table_new = FpTree::HeaderTable.build(row, header_table)
            # Mine extended pattern, new header table
            top_down_fp_growth(header_table_new, pattern_beta)
          end
        end

      end

    end #class

  end
end
