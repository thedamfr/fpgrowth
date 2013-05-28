require_relative 'pattern'
require 'fpgrowth/fp_tree'

module FpGrowth
  module Miner
    class ConditionalTreeBuilder

      def initialize(pattern_base=[], threshold=1)
        @pattern_base = pattern_base
        @threshold = threshold
      end

      def execute(pattern_base=@pattern_base, threshold=@threshold)
        @pattern_base = pattern_base
        @threshold = threshold
        first_pass
        second_pass
      end

      def second_pass(pattern_base=@pattern_base)
        @fp_tree = FpTree::FpTree.new(@supports)
        for pattern in pattern_base
          pattern = sort_by_support(pattern)
          #Look for leaf
          traverse(@fp_tree.root, pattern)
        end
        return @fp_tree
      end

      def first_pass(pattern_base=@pattern_base, threshold=@threshold)
        @pattern_base = pattern_base
        @threshold = threshold
        scan
        pruning
        sort
      end

      def scan(pattern_base=@pattern_base)
        @supports= Hash.new(0)
        for pattern in pattern_base
          for item in pattern.content
            @supports[item] += pattern.support
          end

        end
        return @supports
      end

      # discard unfrequent items
      # @param supports Hash
      #
      def pruning(pattern_base=@pattern_base, supports=@supports, threshold=@threshold)

        total = 0
        pattern_base.each { |x| total += x.support}
        minimum = total.to_f / 100 * threshold

        for pattern in pattern_base
          for item in pattern.content
            pattern.content.delete(item) if supports[item] < minimum
          end
          pattern_base.delete_if { |value| value.content.empty? }
        end
        supports.delete_if { |key, value| value < minimum }

        return supports
      end

      # Ordonner les items en fonction de le support
      # Cet ordre est utilisé pour la construction du Tree lors de la seconde passe
      #
      def sort(supports=@supports)
        Hash[(supports.sort_by { |_key, value| value }.reverse)]
      end


      def sort_by_support(pattern_base)
        lookup = @fp_tree.item_order_lookup

        pattern_base.content.sort_by! do |item|
          lookup.fetch(item, lookup.size + 1)
        end
        return pattern_base
      end


      def traverse(cursor_tree, pattern_base)
        if pattern_base and pattern_base.size > 0
          found = false
          if cursor_tree.item == pattern_base.content.first
            continue_pattern(cursor_tree, pattern_base)
            found = true
          end
          i = 0
          while found == false and i < cursor_tree.children.size
            if cursor_tree.children[i].item == pattern_base.content[0] then
              continue_pattern(cursor_tree.children[i], pattern_base)
              found = true
            end
            i+=1
          end
          fork_pattern(cursor_tree, pattern_base) unless found
        end
      end


      def fork_pattern(cursor_tree, pattern_base)
        node = FpTree::Node.new(pattern_base.content.first, pattern_base.support)
        @fp_tree.append_node(cursor_tree, node)
        cursor_tree = node
        traverse(cursor_tree, Pattern.new(pattern_base.content[1..-1], pattern_base.support))
      end


      def continue_pattern(cursor_tree, pattern_base)
        cursor_tree.support+=pattern_base.support
        traverse(cursor_tree, Pattern.new(pattern_base.content[1..-1], pattern_base.support))
      end


    end
  end
end
