require 'test/unit'
require 'fpgrowth/miner'

class TestMiner < Test::Unit::TestCase


  def test_build_conditional_tree

    fp_tree = FpGrowth::FpTree.build([['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']], 0)
    conditional_tree = nil


    conditional_tree = FpGrowth::Miner.build_conditional_tree(fp_tree, 'a')

    fp_tree.graphviz()
    conditional_tree.graphviz("conditional")


    assert_equal('b', conditional_tree.root.children.first.item)
    assert_equal(2, conditional_tree.root.children.first.support)
    assert_equal([], conditional_tree.root.children.first.children)

    assert_equal(true, conditional_tree.single_path?)

    items= ['a', 'b', 'c', 'd', 'e']

            # Randomized

    r = Random.new
    @n = r.rand(100..500)
    @random_transactions = []
    for i in (0..@n)


      @m = r.rand(0..5)
      @random_transactions[i]=[]
      for j in (0..@m)
        x = r.rand(21)
        if x == 20
          # Trick pour que le 'e' se fasse pruner
        then
          @random_transactions[i] << items[r.rand(items.size)]
        else
          @random_transactions[i] << items[r.rand(items.size - 1)]
        end
      end

    end

    #Trick pour qu'une transaction se fasse vider
    @random_transactions << ['e']

    fp_tree = FpGrowth::FpTree.build(@random_transactions, 1)
    conditional_tree = FpGrowth::Miner.build_conditional_tree(fp_tree, fp_tree.heads.keys[-2])

    fp_tree.graphviz()
    conditional_tree.graphviz("conditional-#{fp_tree.heads.keys[-2]}")

  end
end