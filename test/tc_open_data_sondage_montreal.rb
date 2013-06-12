require 'test/unit'
require 'fpgrowth'
require 'csv'

class TestOpenDataMTLSondage < Test::Unit::TestCase


  def setup

    puts "Setup Test : Open Data Sondage Montreal"

    @transactions = []
    CSV.foreach("test/montreal-sondage/mtlsat12.csv", {:headers => true, :header_converters => :symbol, :header_converters => :symbol, :converters => :all, :encoding => 'windows-1251:utf-8'}) do |row|
      transaction = row.to_a
      transaction.delete_if { |item|
        item[0].to_s.include?("dm") or (item[0].to_s.include?("sd80m") and item[1].to_s == '2') or item[1] == nil or item[1] == nil or item[1].to_s == " " or item[1].to_s.empty?
      }
      @transactions << transaction
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


  def test_fp_growth

    clone = @transactions.clone

    start = Time.now

    fp_tree = FpGrowth::FpTree.build(clone, 1)

    loop = Time.now
    puts "Tree built of size #{fp_tree.size} in #{loop - start}"

    fp_tree.to_bonzai! 90

    loop2 = Time.now
    puts "Tree bonzaied #{fp_tree.size} in :#{loop2 - loop} sec"

    patterns = FpGrowth::Miner.fp_growth(fp_tree)

    patterns.sort! { |a, b| a.support <=> b.support }.reverse!
    finish = Time.now

    puts "Tree Mined in #{finish - loop2}"

    transactions2 = @transactions.clone
    start_td = Time.now
    fp_tree_td = FpGrowth::FpTree.build(transactions2, 1)


    loop_td = Time.now
    puts "Tree built of size #{fp_tree_td.size} in #{loop_td - start_td}"

    fp_tree_td.to_bonzai! 90

    loop2_td = Time.now
    puts "Tree bonzaied to #{fp_tree_td.size} in :#{loop2_td - loop_td} sec"

    patterns_td = FpGrowth::Miner.td_fp_growth(fp_tree_td)

    finish_td = Time.now

    puts "Tree TDMined in #{finish_td - loop2_td}"

    puts "Found #{patterns_td.size} rather than #{patterns.size} with a DeltaTime of #{finish_td - start_td - (finish - start)} it's a #{-(finish_td - start_td - (finish - start)) / (finish - start) * 100}% speedup"


    patterns_td.each {|x| puts "#{x.content} #{ x.support}"}
  end
end