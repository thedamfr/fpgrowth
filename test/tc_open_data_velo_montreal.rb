require 'test/unit'
require 'fpgrowth'
require 'csv'
require 'pp'

class MyTest < Test::Unit::TestCase


  def setup

    @transactions = []
    CSV.foreach("test/montreal-velos-comptage/2012.csv", {:headers => true, :header_converters => :symbol, :header_converters => :symbol, :converters => :all, :encoding => 'windows-1251:utf-8', :col_sep => ";"}) do |row|
      date = Date.parse(row[:date])
      @transactions << [ [:wday, date.wday], [:month, date.month], [:date, row[:date]], [:berri, row[:berri_1]], [:ctesaintecatherine, row[:ctesaintecatherine]], [:maisonneuve_1, row[:maisonneuve_1]], [:maisonneuve_2, row[:maisonneuve_2]], [:du_parc, row[:du_parc]], [:pierredupuy, row[:pierredupuy]], [:rachel, row[:rachel1]]]
    end


    CSV.foreach("test/montreal-velos-comptage/2011.csv", {:headers => true, :header_converters => :symbol, :header_converters => :symbol, :converters => :all, :encoding => 'windows-1251:utf-8', :col_sep => ";"}) do |row|

      date = Date.parse(row[:date])
      mois = date.month
      mois = 2 if row[:date].to_s.match("/f.vr/")
      mois = 3 if row[:date].to_s.include?("avr")
      mois = 5 if row[:date].to_s.include?("mai")
      mois = 6 if row[:date].to_s.include?("juin")
      mois = 7 if row[:date].to_s.include?("juil")
      mois = 8 if row[:date].to_s.match("/ao.t/")
      mois = 9 if row[:date].to_s.match("/d.c/")
      date = Date.new(2011, mois, date.day)
      transaction = [ [:wday, date.wday], [:month, date.month], [:date, row[:date]], [:berri, row[:berri]], [:ctesaintecatherine, row[:ctesaintecatherine]], [:maisonneuve_1, row[:maisonneuve_1]], [:maisonneuve_2, row[:maisonneuve_2]], [:du_parc, row[:du_parc]], [:pierredupuy, row[:pierredupuy]], [:rachel, row[:rachel]]]

      transaction.delete_if { |x| x[1]==nil }
      @transactions << transaction
    end


  end


  def teardown
    # Do nothing
  end

  # Fake test
  def test_fp_growth
    fp_tree = FpGrowth::FpTree.build(@transactions, 1)
    patterns = FpGrowth::Miner.fp_growth(fp_tree)

    patterns.sort! { |a, b| a.support <=> b.support }.reverse!

=begin
    for pattern in patterns
      puts "#{pattern.content} #{pattern.support}"
    end
=end

    assert_not_equal(0, patterns.size)
  end
end