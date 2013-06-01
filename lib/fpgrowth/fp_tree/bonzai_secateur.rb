module FpGrowth
  module FpTree
    class BonzaiSecateur

      def initialize(fp_tree, hardness=20)
        @fp_tree=fp_tree
        @hardness=hardness
      end

      def execute(hardness=@hardness, fp_tree=@fp_tree.clone)
        traverse(fp_tree)
        return fp_tree
      end

      def execute!(hardness=@hardness)
        return execute(hardness, @fp_tree)
      end

      def traverse(fp_tree, cursor = fp_tree.root, deepness=0)
        children = cursor.children.clone
        threshold = cursor.support.to_f / 100 * (@hardness + deepness)
        children.each { |child|
          fp_tree.cut_branch(child) if child.support < threshold
        }
        cursor.children.each { |child| traverse(fp_tree, child, deepness + 1) }
      end

    end
  end
end