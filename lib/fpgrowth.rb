require "fpgrowth/version.rb"
require 'fpgrowth/fp_tree'
require 'fpgrowth/miner'

module FpGrowth
  def self.mine(transactions, threshold=1)
    td_fp_growth(transactions, threshold)
  end

  def self.fp_growth(transactions, threshold=1)
    fp_tree = FpTree.build(transactions, threshold)
    Miner.fp_growth(fp_tree)
  end

  def self.td_fp_growth(transactions, threshold=1)
    fp_tree = FpTree.build(transactions, threshold)
    Miner.td_fp_growth(fp_tree)
  end

end
