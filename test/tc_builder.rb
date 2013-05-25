require 'test/unit'
require 'fpgrowth/fp_tree/builder'

class TestBuilder < Test::Unit::TestCase


  def setup

    items= ['a', 'b', 'c', 'd', 'e']

    r = Random.new

    @n = r.rand(100..500)

    @random_transactions = []
    for i in (0..@n)


      @m = r.rand(1..5)
      @random_transactions[i]=[]
      for j in (0..@m)
        x = r.rand(10)
        if x == 9
          # Trick pour que le 'e' se fasse pruner
        then
          @random_transactions[i] << items[r.rand(items.size)]
        else
          @random_transactions[i] << items[r.rand(items.size - 1)]
        end
      end

    end

    @non_random = [['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']]


  end


  def teardown

  end

  def test_build
    tree = nil
    assert_nothing_raised { tree = FpGrowth::FpTree::Builder.build(@non_random, 0.5) }
    assert_not_nil(tree)
    assert_instance_of(FpGrowth::FpTree::FpTree, tree)



    assert_equal(nil,tree.root.item)
    assert_equal(1, tree.root.children.size)
    assert_equal('b', tree.root.children.first.item)
    assert_equal('a', tree.root.children.first.children.first.item)
    assert_equal('c', tree.root.children.first.children.last.item)

    assert_nothing_raised { tree = FpGrowth::FpTree::Builder.build(@random_transactions) }
    assert_not_nil(tree)
    assert_instance_of(FpGrowth::FpTree::FpTree, tree)


  end

end