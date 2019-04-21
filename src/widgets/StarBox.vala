using Gtk;

namespace DFLib.Widgets {
    public class StarBox : Bin {
        public int stars {
            get { return _stars; }
            set {
                int clamp_value = value.clamp (0, 5);

                if (_stars != clamp_value) {
                    _stars = clamp_value;

                    if (_buttons != null) {
                        for (int i = 0; i < 5; ++i) {
                            var image = _buttons[i].image as Image;
                            image.icon_name = index_to_icon_name (i);
                        }
                    }

                    stars_changed (_stars);
                }
            }
        }
        private int _stars = 0;

        public signal void stars_changed (int stars);

        construct {
            var sub_box = new Box (Orientation.HORIZONTAL, 0);
            sub_box.get_style_context ().add_class ("linked");

            _buttons = new Button[5];
            for (int i = 0; i < 5; ++i) {
                _buttons[i] = new Button ();
                _buttons[i].set_image (new Image.from_icon_name (index_to_icon_name (i), IconSize.BUTTON));
                int star_value = i + 1;
                _buttons[i].clicked.connect (() => {
                    stars = star_value;
                });

                sub_box.pack_start (_buttons[i], true, true);
            }

            add (sub_box);
            show_all ();
        }

        private string index_to_icon_name (int index) {
            return index < _stars ? "starred-symbolic" : "non-starred-symbolic";
        }

        private Button[] _buttons;
    }
}
