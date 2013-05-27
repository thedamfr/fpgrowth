require 'fpgrowth/fp_tree/node'

module FpGrowth
  module Miner
    class Pattern
      attr_reader :content
      attr_accessor :support

      def initialize(content=[], support = 0)
        @content = content
        @support = support
      end

      def +(y)
        return self unless y
        return Pattern.new(@content + y.content, [@support, y.support].min)
      end

      def <<(y)
        if y.is_a?(Array)
          min_support = @support
          for node in y
            unless @content.include?(node.item)
              @content << node.item
              if min_support > node.support then
                min_support = node.support
              end
            end
          end
          @support = min_support
        elsif y.is_a?(FpTree::Node)
          self << [y]
        end

      end

      def size
        @content.size
      end

      def clone
        return Pattern.new(@content.clone, @support)
      end

    end
  end
end