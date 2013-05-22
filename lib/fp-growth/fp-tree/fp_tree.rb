class FpTree
  attr_reader :root, :heads, :supports
  @root = Node.new()
  @heads = Hash.new nil
  @lookup = {}

  def initialize(supports={})
    @supports = supports
    #initialiser les clés
    for k in @supports.keys
      @heads[k]
    end
  end

  def item_order_lookup
    unless @lookup
      @supports.keys.each_with_index do |item, index|
        lookup[item] = index
      end
    end
    return @lookup
  end

  def find_lateral_leaf_for_item(item)
    cursor = heads[item]
    while cursor != nil do
      cursor = cursor.lateral
    end
    return cursor
  end


end