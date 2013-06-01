require 'test/unit'
require 'fpgrowth'
require 'csv'

class TestOpenDataMTLSondage < Test::Unit::TestCase


  def setup

    @transactions = []
    CSV.foreach("test/montreal-sondage/mtlsat12.csv", {:headers => true, :header_converters => :symbol, :header_converters => :symbol, :converters => :all, :encoding => 'windows-1251:utf-8'}) do |row|
      transaction = row.to_a
      transaction.delete_if { |item|
        item[0].to_s.include?("dm") or (item[0].to_s.include?("sd80m") and item[1].to_s == '2') or item[1] == nil or item[1] == nil or item[1].to_s == " " or item[1].to_s.empty?
      }
      @transactions << transaction

    end

  end


  def teardown
    # Do nothing
  end


  def test_fp_growth

    d = Time.now
    puts "Start time : "+d.to_s

    fp_tree = FpGrowth::FpTree.build(@transactions, 1)

    loop = Time.now
    puts "Tree of size #{fp_tree.size} built in :#{loop-d}"


    bonzai = fp_tree.to_bonzai! 90

    loop2 = Time.now
    puts "Tree bonzaied to #{bonzai.size}-#{bonzai.max_width} in :#{loop2 - loop} sec"


    patterns = FpGrowth::Miner.fp_growth(bonzai)

    f=Time.now
    puts "Mining took #{(f-d)}sec"

   # patterns.sort! { |a, b| a.support <=> b.support }.reverse!

    for pattern in patterns
   #   puts "#{pattern.content} #{pattern.support}"
    end

    assert_not_equal(0, patterns.size)
  end
end