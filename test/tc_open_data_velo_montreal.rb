require 'test/unit'
require 'fpgrowth'
require 'csv'

class TestOpenDataVelo < Test::Unit::TestCase


  def setup

    @transactions = []
    CSV.foreach("test/montreal-velos-comptage/2012.csv", {:headers => true, :header_converters => :symbol, :header_converters => :symbol, :converters => :all, :encoding => 'windows-1251:utf-8', :col_sep => ";"}) do |row|
      date = Date.parse(row[:date])
      @transactions << [[:wday, date.wday], [:month, date.month], [:date, row[:date]], [:berri, row[:berri_1]], [:ctesaintecatherine, row[:ctesaintecatherine]], [:maisonneuve_1, row[:maisonneuve_1]], [:maisonneuve_2, row[:maisonneuve_2]], [:du_parc, row[:du_parc]], [:pierredupuy, row[:pierredupuy]], [:rachel, row[:rachel1]]]
    end


  end


  def teardown
    # Do nothing
  end

  # Fake test
  def test_fp_growth
    start = Time.now
    fp_tree = FpGrowth::FpTree.build(@transactions.clone, 1)

    loop = Time.now
    puts "Tree built of size #{fp_tree.size} and total item #{fp_tree.sum} / #{fp_tree.lateral_sum} in #{loop - start}"

    patterns_rough = FpGrowth::Miner.fp_growth(fp_tree)

    lookup = Hash.new 0
    patterns_rough.each { |pattern|
      lookup[pattern.content.sort { |x, y| x[0].to_s <=> y[0].to_s }] += pattern.support
    }
    patterns = []
    lookup.each { |key, value|
      patterns << FpGrowth::Miner::Pattern.new(key, value)
    }

    patterns.sort! { |a, b| a.support <=> b.support }.reverse!
    finish = Time.now

    fp_tree.graphviz


    for pattern in patterns[0..10]
      puts "#{pattern.content} #{pattern.support}"
    end
    puts "Tree Mined in #{finish - loop}"


    start_td = Time.now
    fp_tree_td = FpGrowth::FpTree.build(@transactions, 1)

    loop_td = Time.now

    patterns_td = FpGrowth::Miner.td_fp_growth(fp_tree_td)


    finish_td = Time.now


    patterns_td.sort! { |a, b| a.support <=> b.support }.reverse!
    for pattern in patterns_td[0..100]
      puts "#{pattern.content} : #{pattern.support}"
    end
    puts "Tree built in #{loop_td - start_td} TDMined in #{finish_td - loop_td}"
    puts "Found #{patterns_td.size} rather than #{patterns.size} with a DeltaTime of #{finish_td - start_td - (finish - start)}"


    assert_not_equal(0, patterns.size)
  end
end