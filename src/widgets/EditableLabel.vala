using Gtk;
using Pango;

namespace DFLib.Widgets {
    public class EditableLabel : Bin {
        public string text {
            get { return _text; }
            set {
                if (_text != value) {
                    _text = value;

                    if (_label != null) {
                        _label.label = _text;
                    }
                    if (_entry != null) {
                        _entry.text = _text ?? "";
                    }

                    text_changed (text);
                }
            }
        }
        private string _text;

        public bool edit_mode {
            get { return _edit_mode; }
            set {
                if (_edit_mode != value) {
                    _edit_mode = value;

                    if (_stack != null) {
                        _stack.visible_child_name = _edit_mode ? "edit" : "display";
                    }

                    if (_edit_mode && _entry != null) {
                        _entry.text = text ?? "";
                    }
                }
            }
        }
        private bool _edit_mode = false;

        public Label label { get { return _label; } }

        public signal void text_changed (string text);

        construct {
            _stack = new Stack ();

            _entry = new Entry ();
            _entry.text = _text ?? "";
            _entry.secondary_icon_name = "edit-clear-symbolic";
            _entry.valign = Align.CENTER;

            _entry.activate.connect (accept);
            _entry.icon_release.connect (icon_release);
            _stack.add_named (_entry, "edit");

            var box = new Box (Orientation.HORIZONTAL, 6);
            var edit_button = new Button.from_icon_name ("gtk-edit");
            edit_button.clicked.connect (() => edit_mode = true);
            _label = new Label (text);

            box.add (_label);
            edit_button.halign = Align.CENTER;
            edit_button.valign = Align.CENTER;
            box.pack_end (edit_button, false, false);
            _stack.add_named (box, "display");

            add (_stack);
            show_all ();
            _stack.visible_child_name = _edit_mode ? "edit" : "display";
        }

        public void accept () {
            if (edit_mode) {
                text = _entry.text;
                edit_mode = false;
            }
        }

        private void icon_release () {
            edit_mode = false;
        }

        private Stack _stack;
        private Label _label;
        private Entry _entry;
    }
}
