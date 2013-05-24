require_relative 'builder/first_pass'
require_relative 'builder/second_pass'


module FpGrowth
  module FpTree
    module Builder

      def self.build(transactions)
        first_pass = FirstPass.new()
        supports = first_pass.execute(transactions)
        second_pass = SecondPass.new(supports)
        tree = second_pass.execute(transactions)

        tree.graphviz

        return tree
      end

    end
  end
end
