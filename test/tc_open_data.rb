require 'test/unit'
require 'fpgrowth'
require 'csv'
require 'pp'

class MyTest < Test::Unit::TestCase


  def setup

    @transactions = []
    CSV.foreach("test/montreal-velos-comptage/2012.csv", {:headers => true, :header_converters => :symbol, :header_converters => :symbol, :converters => :all, :encoding => 'windows-1251:utf-8', :col_sep => ";"}) do |row|
      @transactions << [[:date, row[:date]], [:berri_1, row[:berri_1]], [:ctesaintecatherine, row[:ctesaintecatherine]], [:maisonneuve_1, row[:maisonneuve_1]], [:maisonneuve_2, row[:maisonneuve_2]], [:du_parc, row[:du_parc]], [:pierredupuy, row[:pierredupuy]], [:rachel1, row[:rachel1]]]
    end


  end


  def teardown
    # Do nothing
  end

  # Fake test
  def test_fp_growth
    fp_tree = FpGrowth::FpTree.build(@transactions, 1)
    patterns = FpGrowth::Miner.fp_growth(fp_tree)

    for pattern in patterns
      puts "#{pattern.content} #{pattern.support}"
    end

  end
end