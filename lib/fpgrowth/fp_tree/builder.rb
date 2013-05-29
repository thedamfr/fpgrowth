require_relative 'builder/first_pass'
require_relative 'builder/second_pass'


module FpGrowth
  module FpTree
    module Builder

      def self.build(transactions, threshold=1)
        first_pass = FirstPass.new(threshold)
        supports = first_pass.execute(transactions)
        second_pass = SecondPass.new(supports, threshold)
        tree = second_pass.execute(transactions)
        return tree
      end

    end
  end
end
