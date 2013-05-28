require_relative 'fp_tree/node'
require_relative 'fp_tree/builder'

require 'graphviz'
require 'etc'

module FpGrowth
  module FpTree

    def self.build(transactions, threshold=1)
      Builder.build(transactions, threshold)
    end

    class FpTree
      attr_reader :root, :heads, :supports, :threshold

      def self.build(transactions, threshold=1)
        Builder.build(transactions, threshold)
      end

      def initialize(supports={}, threshold=1)
        @root = Node.new()
        @heads = Hash.new nil
        @supports = supports
        #initialiser les clés
        for k in @supports.keys
          @heads[k]=nil
        end
        @threshold=threshold
      end

      def item_order_lookup
        unless @lookup
          @lookup = {}
          @supports.keys.each_with_index do |item, index|
            @lookup[item] = index
          end
        end
        return @lookup

      end

      def find_lateral_leaf_for_item(item)
        cursor = heads[item]
        while cursor != nil and cursor.lateral != nil do
          cursor = cursor.lateral
        end
        return cursor
      end

      def graphviz(fancy_name=nil)
        g = GraphViz.new(:G, :type => :digraph)
        nodonode = {}
        nodonode[self.root]=g.add_nodes(self.root.to_s, :label => "nil")

        for row in self.heads.values
          node=row
          while node != nil
            nodonode[node]= g.add_nodes(node.to_s, :label => node.item.to_s + " : " + node.support.to_s)
            node = node.lateral
          end
        end

        for child in self.root.children
          g.add_edges(nodonode[self.root], nodonode[child])
        end

        for row in self.heads.values
          node=row
          while node != nil
            for child in node.children
              g.add_edges(nodonode[node], nodonode[child])
            end
            node = node.lateral
          end
        end


        for row in self.heads.values
          node=row
          while node != nil

            g.add_edges(nodonode[node], nodonode[node.lateral], :style => :dashed, :constraint => :false) if node.lateral
            node = node.lateral
          end
        end

        g.output(:png => "./graphs/#{fancy_name}-#{Etc.getlogin}-#{items_count}-items-#{Time.now.to_s.gsub(" ", "-")}.png")

      end

      def sort_children_by_support(nodes)
        lookup = item_order_lookup

        nodes.sort_by! do |node|
          lookup.fetch(node.item, lookup.size + 1)
        end
      end

      def append_node(cursor_tree, node)
        cursor_tree.children << node
        node.parent = cursor_tree
        sort_children_by_support(cursor_tree.children)
        left = find_lateral_leaf_for_item(node.item)
        if left == nil then
          @heads[node.item] = node
        else
          left.lateral = node
        end
      end

      def items_count
        sum=0
        for val in supports.values
          sum+=val
        end
        return sum

      end

      def single_path?
        is = true
        cursor = @root
        while is and cursor != nil
          is = false if cursor.children.size > 1
          cursor = cursor.children.first
        end

        return is
      end

      def combinations
        raise "Tree contains multiple paths" unless single_path?
        array = []
        item = @root.children.first
        while item != nil
          array << item
          item = item.children.first
        end
        yss = 1.upto(array.size).flat_map do |n|
          array.combination(n).to_a
        end
      end

      def empty?
        return @heads.empty?
      end

    end
  end
end

require_relative 'fp_tree/builder'