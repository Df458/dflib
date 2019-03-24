using Gee;
using Gtk;

namespace DFLib {
    // Represents the result of a filter operation
    public enum TreeFilterResult {
        SHOW,               // Visible
        HIDE,               // Hidden
        SHOW_WITH_CHILDREN, // Hidden, unless a child is visible
    }

    // A TreeModelFilter with additional filtering results
    public class AdvancedTreeModelFilter : TreeModelFilter {
        public AdvancedTreeModelFilter(TreeModel child, TreePath? root, int visible_column) {
            Object(child_model: child, virtual_root: root);
            _visible_column = visible_column;
            set_visible_column(visible_column);
        }

        // Recursively filter all nodes in the tree
        // Use this in place of TreeModelFilte.refilter()
        public void filter() {
            TreeIter? iter = null;
            if(virtual_root == null) {
                if(!child_model.get_iter_first(out iter)) {
                    warning("Can't get initial iterator");
                    iter = null;
                }
            } else if(!child_model.get_iter(out iter, virtual_root)) {
                warning("Can't get initial iterator");
            }

            if(iter == null) {
                return;
            }

            filter_step(iter);
        }

        // Check if a node is visible
        protected virtual TreeFilterResult is_visible(TreeIter iter) {
            return TreeFilterResult.SHOW;
        }

        // Recursive step for filtering nodes, called by filter()
        private void filter_step(TreeIter? iter, ArrayQueue<TreeIter?> parents = new ArrayQueue<TreeIter?>()) {
            TreeIter child = iter;
            // Iterate all siblings
            do {
                // Filter this node
                TreeFilterResult res = is_visible(child);
                switch(res) {
                    case TreeFilterResult.SHOW:
                        (child_model as TreeStore).set(child, _visible_column, true);

                        foreach(TreeIter? i in parents) {
                            (child_model as TreeStore).set(i, _visible_column, true);
                        }
                        parents.clear();
                        break;
                    case TreeFilterResult.HIDE:
                        (child_model as TreeStore).set(child, _visible_column, false);
                        break;
                    case TreeFilterResult.SHOW_WITH_CHILDREN:
                        (child_model as TreeStore).set(child, _visible_column, false);
                        parents.offer_tail(child);
                        break;
                }

                // If the branch isn't hidden, filter the children
                TreeIter? new_iter = null;
                if(res != TreeFilterResult.HIDE) {
                    if(child_model.iter_children(out new_iter, child)) {
                        filter_step(new_iter, parents);
                    }

                    // If there are no visible children, remove from the queue manually
                    if(res == TreeFilterResult.SHOW_WITH_CHILDREN && parents.peek_tail() == child) {
                        parents.poll_tail();
                    }
                }
            } while(child_model.iter_next(ref child));
        }

        // The visible column passed to TreeModelFilter.set_visible_column(). Used for custom filtering.
        private int _visible_column;
    }
}
