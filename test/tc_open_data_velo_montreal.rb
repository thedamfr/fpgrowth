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
    fp_tree = FpGrowth::FpTree.build(@transactions, 1)
    loop = Time.now
    puts "Tree built in #{loop - start}"

    patterns = FpGrowth::Miner.fp_growth(fp_tree)

    finish = Time.now
    puts "Tree Mined in #{finish - loop}"


    patterns.sort! { |a, b| a.support <=> b.support }.reverse!


    for pattern in patterns
      puts "#{pattern.content} #{pattern.support}"
    end

    loop_td = Time.now

    patterns_td = FpGrowth::Miner.td_fp_growth(fp_tree)

    finish_td = Time.now
    puts "Tree TDMined in #{finish_td - loop_td}"



    for pattern in patterns_td
      puts "#{pattern.content} : #{pattern.support}"
    end


    assert_not_equal(0, patterns.size)
  end
end