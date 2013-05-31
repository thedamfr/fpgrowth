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

      def traverse(fp_tree, cursor = fp_tree.root)
        children = cursor.children.clone
        children.each { |child|
          fp_tree.cut_branch(child) if child.support < (cursor.support * 100 / @hardness)
        }
        cursor.children.each { |child| traverse(fp_tree, child) }
      end

    end
  end
end