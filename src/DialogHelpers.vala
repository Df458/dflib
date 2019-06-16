using Gtk;

namespace DFLib {
    public enum ActionType {
        STANDARD,
        SUGGESTED,
        DESTRUCTIVE
    }

    public class DialogHelpers {
        /** Display a dialog prompting the user to take an action
         *
         * @param parent The parent window
         * @param title The window title
         * @param details Text to display in the window body
         * @param action_label Text to display on the confirmation button
         * @param type Enum for controlling the appearance of the confirmation button
         */
        public static bool confirm (Window? parent, string title, string details, string action_label, ActionType type = ActionType.STANDARD) {
            var dlg = new Dialog.with_buttons (title, parent, DialogFlags.MODAL | DialogFlags.USE_HEADER_BAR, action_label, ResponseType.OK, "Cancel", ResponseType.CANCEL);
            var label = new Label (details);
            label.margin = 12;
            label.wrap = true;
            dlg.get_content_area ().add (label);

            switch (type) {
                case ActionType.SUGGESTED:
                    dlg.get_widget_for_response (ResponseType.OK).get_style_context ().add_class ("suggested-action");
                    break;
                case ActionType.DESTRUCTIVE:
                    dlg.get_widget_for_response (ResponseType.OK).get_style_context ().add_class ("destructive-action");
                    break;
            }

            dlg.get_content_area ().show_all ();

            bool result = dlg.run () == ResponseType.OK;

            dlg.close ();

            return result;
        }
    }
}
