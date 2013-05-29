require 'test/unit'

class TestEnelOpenData < Test::Unit::TestCase


  def setup
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

    start = Time.now
    fp_tree = FpGrowth::FpTree.build(@transactions_canada_processi_prodotti, 1)
    loop = Time.now
    puts "Tree built in #{loop - start}"

    patterns = FpGrowth::Miner.fp_growth(fp_tree)

    finish = Time.now
    puts "Tree Mined in #{finish -start}"

    patterns.sort! { |a, b| a.support <=> b.support }.reverse!

    #patterns.each { |pattern| puts "<#{pattern.content}:#{pattern.support}>"}


    assert_not_equal(0, patterns.size)

  end

  def test_canada_produzione_impianti_termoelecttrici

    start = Time.now
    fp_tree = FpGrowth::FpTree.build(@transactions_produzione_impianti_termoelecttrici, 1)
    loop = Time.now
    puts "Tree built in #{loop - start}"
    patterns = FpGrowth::Miner.fp_growth(fp_tree)
    finish = Time.now
    puts "Tree Mined in #{finish - start}"

    patterns.sort! { |a, b| a.support <=> b.support }
    patterns.sort! { |a, b| a.content.length <=> b.content.length }

    assert_not_equal(0, patterns.size)

    #patterns.each { |pattern| puts "<#{pattern.content}:#{pattern.support}>" if pattern.support > 1}

  end

end