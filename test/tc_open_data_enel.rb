require 'test/unit'

class TestEnelOpenData < Test::Unit::TestCase


  def setup

    puts "Setup Test : Open Data Enel"

    @transactions_canada_processi_prodotti = []
    CSV.foreach("test/enel/3_canada_i_processi_e_i_prodotti_1.csv", {:headers => true, :header_converters => :symbol, :header_converters => :symbol, :converters => :all, :col_sep => "\t"}) do |row|
      @transactions_canada_processi_prodotti << row.to_a
    end
    @transactions_produzione_impianti_termoelecttrici = []
    CSV.foreach("test/enel/Produzione_Impianti_Termoelettrici_en.csv", {:headers => true, :header_converters => :symbol, :header_converters => :symbol, :converters => :all, :col_sep => "\t"}) do |row|
      transaction = [[:tipo, [row[:tipo]]], [:sezioni, row[:sezioni]]]
      potenza_lorda = row[:potenza_lorda_mw].to_s.gsub(',', '').to_i
      if potenza_lorda < 10
        transaction << [:lorda_order, "<10"]
      elsif potenza_lorda > 10 and potenza_lorda < 100
        transaction << [:lorda_order, ">10"]
      elsif potenza_lorda > 100 and potenza_lorda < 1000
        transaction << [:lorda_order, ">100"]
      elsif potenza_lorda > 1000
        transaction << [:lorda_order, ">1000"]
      end
      transaction.delete_if { |item| item[1]==nil }
      @transactions_produzione_impianti_termoelecttrici << transaction
    end
  end

  def teardown

  end

  def test_canada_processi_prodotti


    total_item = 0
    min = @transactions_canada_processi_prodotti[0].size
    max = 0
    @transactions_canada_processi_prodotti.each { |transaction|
      total_item += transaction.size
      min = transaction.size if transaction.size < min
      max = transaction.size if transaction.size > max
    }
    average = total_item / @transactions_canada_processi_prodotti.size

    puts "Test Canada Processi Prodotti"
    puts "Extracted #{@transactions_canada_processi_prodotti.size} transactions"
    puts "With a total of #{total_item} items"
    puts "min:#{min} avg:#{average} max:#{max} items/sets"
    transactions_canada_processi_prodotti1 = @transactions_canada_processi_prodotti.clone
    transactions_canada_processi_prodotti2 = @transactions_canada_processi_prodotti.clone

    start = Time.now
    fp_tree = FpGrowth::FpTree.build(transactions_canada_processi_prodotti1, 1)

    loop = Time.now
    puts "Tree built of size #{fp_tree.size} in #{loop - start}"

    patterns = FpGrowth::Miner.fp_growth(fp_tree)

    finish = Time.now
    puts "Tree Mined in #{finish - loop}"

    patterns.sort! { |a, b| a.support <=> b.support }.reverse!

    assert_not_equal(0, patterns.size)

    start_td = Time.now
    fp_tree_td = FpGrowth::FpTree.build(transactions_canada_processi_prodotti2, 1)

    loop_td = Time.now
    puts "Tree built of size #{fp_tree.size} in #{loop_td - start_td}"

    patterns_td = FpGrowth::Miner.td_fp_growth(fp_tree_td)

    finish_td = Time.now

    puts "Tree built in #{loop_td - start_td} TDMined in #{finish_td - loop_td}"

    puts "Found #{patterns_td.size} rather than #{patterns.size} with a DeltaTime of #{finish_td - start_td - (finish - start)} it's a #{-(finish_td - start_td - (finish - start)) / (finish - start) * 100}% speedup"


    assert_not_equal(0, patterns.size)

  end

  def test_canada_produzione_impianti_termoelecttrici


    total_item = 0
    min = @transactions_produzione_impianti_termoelecttrici[0].size
    max = 0
    @transactions_produzione_impianti_termoelecttrici.each { |transaction|
      total_item += transaction.size
      min = transaction.size if transaction.size < min
      max = transaction.size if transaction.size > max
    }
    average = total_item / @transactions_produzione_impianti_termoelecttrici.size

    puts "Test Canada Produzione Impianti Termoelecttrici"
    puts "Extracted #{@transactions_produzione_impianti_termoelecttrici.size} transactions"
    puts "With a total of #{total_item} items"
    puts "min:#{min} avg:#{average} max:#{max} items/sets"
    transactions_produzione_impianti_termoelecttrici1 = @transactions_produzione_impianti_termoelecttrici.clone
    transactions_produzione_impianti_termoelecttrici2 = @transactions_produzione_impianti_termoelecttrici.clone

    start = Time.now
    fp_tree = FpGrowth::FpTree.build(transactions_produzione_impianti_termoelecttrici1, 1)
    loop = Time.now
    puts "Tree built of size #{fp_tree.size} in #{loop - start}"
    patterns = FpGrowth::Miner.fp_growth(fp_tree)
    finish = Time.now
    puts "Tree Mined in #{finish - loop}"

    assert_not_equal(0, patterns.size)

    start_td = Time.now
    fp_tree_td = FpGrowth::FpTree.build(transactions_produzione_impianti_termoelecttrici2, 1)

    loop_td = Time.now
    puts "Tree built of size #{fp_tree_td.size} in #{loop_td - start_td}"

    patterns_td = FpGrowth::Miner.td_fp_growth(fp_tree_td)

    finish_td = Time.now

    puts "Tree built in #{loop_td - start_td} TDMined in #{finish_td - loop_td}"

    puts "Found #{patterns_td.size} rather than #{patterns.size} with a DeltaTime of #{finish_td - start_td - (finish - start)} it's a #{-(finish_td - start_td - (finish - start)) / (finish - start) * 100}% speedup"


    assert_not_equal(0, patterns.size)


  end

end