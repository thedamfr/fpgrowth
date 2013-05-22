require "lib/fp-growth/models/transaction"

module FpGrowth
  module FpTree
    module Builder
      class FirstPass

        attr_accessor :supports
        @supports = Hash.new()

        # Scan data and find support for each item
        # @param transactions FpGrowth::Transaction
        #
        #
        def scan(transactions)
          @supports= Hash.new()
          for transaction in transactions
            for item in transaction.items
              @supports[item]=0 unless @supports[item]
              @supports[item] += 1
            end

          end
          return @supports
        end

        # discard infrequent items
        # @param supports Hash
        #
        def pruning(supports=@supports)
          sum=0
          for val in supports.values
            sum+=val
          end
          average = sum / supports.size
          supports.delete_if { |key, value| value < (average / 10) }
          return supports
        end

        def sort(supports=@supports)
          supports.sort_by {|_key, value| value}
        end

        # Actually make the first pass
        #
        def execute(transactions)
          scan(transactions)
          pruning()
          sort()
        end

      end
    end
  end
end
