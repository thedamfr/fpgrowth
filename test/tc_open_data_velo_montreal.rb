require 'test/unit'
require 'fpgrowth'
require 'csv'

class TestOpenDataVelo < Test::Unit::TestCase


  def setup

    puts "Setup Test : Open Data Velo Montreal"

    @transactions = []
    CSV.foreach("test/montreal-velos-comptage/2012.csv", {:headers => true, :header_converters => :symbol, :header_converters => :symbol, :converters => :all, :encoding => 'windows-1251:utf-8', :col_sep => ";"}) do |row|
      date = Date.parse(row[:date])
      @transactions << [[:wday, date.wday], [:month, date.month], [:date, row[:date]], [:berri, row[:berri_1]], [:ctesaintecatherine, row[:ctesaintecatherine]], [:maisonneuve_1, row[:maisonneuve_1]], [:maisonneuve_2, row[:maisonneuve_2]], [:du_parc, row[:du_parc]], [:pierredupuy, row[:pierredupuy]], [:rachel, row[:rachel1]]]
    end

    total_item = 0
    min = @transactions[0].size
    max = 0
    @transactions.each { |transaction|
      total_item += transaction.size
      min = transaction.size if transaction.size < min
      max = transaction.size if transaction.size > max
    }
    average = total_item / @transactions.size


    puts "Extracted #{@transactions.size} transactions"
    puts "With a total of #{total_item} items"
    puts "min:#{min} avg:#{average} max:#{max} items/sets"


  end


  def teardown
    # Do nothing
  end

  # Fake test
  def test_fp_growth
    transactions1 = @transactions.clone

    # Début
    start = Time.now
    fp_tree = FpGrowth::FpTree.build(transactions1, 1)

    loop = Time.now
    puts "Tree built of size #{fp_tree.size} in #{loop - start}"

    patterns = FpGrowth::Miner.fp_growth(fp_tree)

    patterns.sort! { |a, b| a.support <=> b.support }.reverse!
    finish = Time.now

    puts "Tree Mined in #{finish - loop}"
    assert_not_equal(0, patterns.size)
    # Fin

    transactions2 = @transactions.clone
    start_td = Time.now
    fp_tree_td = FpGrowth::FpTree.build(transactions2, 1)


    loop_td = Time.now
    puts "Tree built of size #{fp_tree_td.size} in #{loop_td - start_td}"

    patterns_td = FpGrowth::Miner.td_fp_growth(fp_tree_td)

    finish_td = Time.now

    puts "Tree built in #{loop_td - start_td} TDMined in #{finish_td - loop_td}"

    puts "Found #{patterns_td.size} rather than #{patterns.size} with a DeltaTime of #{finish_td - start_td - (finish - start)} it's a #{-(finish_td - start_td - (finish - start)) / (finish - start) * 100}% speedup"


    assert_not_equal(0, patterns.size)
  end
end