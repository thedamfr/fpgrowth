require 'test/unit'
require "fpgrowth/fp_tree"
require "fpgrowth/fp_tree/node"
require "fpgrowth/fp_tree/builder/first_pass"

class TestFpTree < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # test initialize
  def test_initialize

    fp_tree = nil
    # no arguments
    assert_nothing_raised {fp_tree = FpGrowth::FpTree::FpTree.new()}
    assert_not_nil( fp_tree.root )
    assert_instance_of( FpGrowth::FpTree::Node , fp_tree.root )
    assert_instance_of( Hash , fp_tree.heads )
    assert_equal( {} , fp_tree.supports )

    # list empty
    assert_nothing_raised {fp_tree = FpGrowth::FpTree::FpTree.new({})}
    assert_not_nil( fp_tree.root )
    assert_instance_of( FpGrowth::FpTree::Node , fp_tree.root )
    assert_instance_of( Hash , fp_tree.heads )
    assert_equal( {} , fp_tree.supports )


    # list with arguments
    support =  { 'a' => 1, 'b' => 2}
    assert_nothing_raised {fp_tree = FpGrowth::FpTree::FpTree.new(support)}
    assert_not_nil( fp_tree.root )
    assert_instance_of( FpGrowth::FpTree::Node , fp_tree.root )
    assert_instance_of( Hash , fp_tree.heads )
    assert( fp_tree.heads.has_key?('a') , "a n'existe pas")
    assert( fp_tree.heads.has_key?('b') ,"b n'existe pas !" )
    assert_equal( 2 , fp_tree.heads.length )
    assert( fp_tree.supports.has_key?('a') , "a n'existe pas")
    assert( fp_tree.supports.has_key?('b') ,"b n'existe pas !" )
    assert_equal( 2 , fp_tree.supports.length )

  end

  # test item_oder_lookup
  def test_item_oder_lookup

    # look up with fp_tree nul
    fp_tree = nil
    # no arguments
    assert_nothing_raised {fp_tree = FpGrowth::FpTree::FpTree.new()}
    lookup = fp_tree.item_order_lookup
    assert_equal( {} , lookup )

    # look up with fp_tree non null
    support =  { 'a' => 1, 'b' => 2}
    assert_nothing_raised {fp_tree = FpGrowth::FpTree::FpTree.new(support)}
    lookup = fp_tree.item_order_lookup
    assert_equal( 0  , lookup['a'] )
    assert_equal( 1  , lookup['b'] )

  end

  # test  find_lateral_leaf_for_item
  def test_find_lateral_leaf_for_item

  end

  def test_sort_children_by_support
    @non_random = [['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']]
    @supports_non_random = FpGrowth::FpTree::Builder::FirstPass.new().execute(@non_random)

    secondPass = FpGrowth::FpTree::Builder::SecondPass.new(@supports_non_random)

    list = [FpGrowth::FpTree::Node.new('a'), FpGrowth::FpTree::Node.new('c'), FpGrowth::FpTree::Node.new('b')]


    assert_nothing_raised { secondPass.fp_tree.sort_children_by_support(list) }


    assert_equal(@supports_non_random.keys.first, list.first.item)
    assert_equal(@supports_non_random.keys[1], list[1].item)


  end


  def test_append_node
    parent = FpGrowth::FpTree::Node.new()
    child = FpGrowth::FpTree::Node.new('a')
    @non_random = [['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']]
    @supports_non_random = FpGrowth::FpTree::Builder::FirstPass.new().execute(@non_random)


    #Ajout first
    secondPass = FpGrowth::FpTree::Builder::SecondPass.new(@supports_non_random)

    assert_nothing_raised { secondPass.fp_tree.append_node(parent, child) }
    assert_not_equal(0, parent.children.size)
    assert_equal(child, parent.children.last)
    assert_equal(child, secondPass.fp_tree.heads['a'])
    assert_equal(parent, child.parent)

    #Ajout lateral

    child = FpGrowth::FpTree::Node.new('a')

    assert_nothing_raised() { secondPass.fp_tree.append_node(parent, child) }
    assert_not_equal(0, parent.children.size)
    assert_equal(child, parent.children[1])
    assert_equal(child, secondPass.fp_tree.heads['a'].lateral)

    #Ajout en profondeur
    parent = parent.children[0]

    child = FpGrowth::FpTree::Node.new('b')

    assert_nothing_raised() { secondPass.fp_tree.append_node(parent, child) }
    assert_not_equal(0, parent.children.size)
    assert_equal(child, parent.children[0])
    assert_equal(child, secondPass.fp_tree.heads['b'])
    assert_equal(parent, child.parent)

    # Verifier l'ordre des enfants
    parent = FpGrowth::FpTree::Node.new()
    child = FpGrowth::FpTree::Node.new('a')
    child2 = FpGrowth::FpTree::Node.new('b')


    assert_nothing_raised() { secondPass.fp_tree.append_node(parent, child) }
    assert_nothing_raised() { secondPass.fp_tree.append_node(parent, child2) }

    assert_equal('b', parent.children.first.item)
    assert_equal('a', parent.children.last.item)


  end

  def test_single_path
    fail("ToDo")
  end

end