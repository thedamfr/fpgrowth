module FpGrowth
  module Miner
    class Miner
      def build_conditionnal_tree(tree, pattern)
        case pattern
          when Array
            return build_conditionnal_tree(build_conditionnal_tree(tree, pattern[0]), pattern[1..-1])
          else

            #Todo : Implement tree traversing etc...

        end

      end
    end
  end
end
