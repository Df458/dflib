using Gtk;

public class CheckListEntry<T> : ListBoxRow
{
    public bool checked { get; private set; }
    public string title { get { return label.label;} }
    public T data { get; private set; }
    private Box box;
    private Image check;
    private Label label;
    private Revealer check_revealer;

    public CheckListEntry(string label_str, T data_in, bool checked_value = false)
    {
        box = new Box(Orientation.HORIZONTAL, 12);
        box.margin = 12;
        label = new Label(label_str);
        label.halign = Align.START;
        check = new Image.from_icon_name("object-select-symbolic", IconSize.BUTTON);
        check_revealer = new Revealer();
        check_revealer.reveal_child = checked;
        data = data_in;

        box.pack_start(this.label, true, true);
        check_revealer.add(this.check);
        box.pack_end(check_revealer, false, false);
        checked = checked_value;

        add(box);
    }

    public bool toggle()
    {
        checked = !checked;
        check_revealer.reveal_child = checked;
        return checked;
    }
}

public abstract class SelectionPopover<T> : Popover
{
    private ListBox tag_list;
    private SearchEntry search_entry;
    
    private Gee.HashMap<string, T> options;

    public SelectionPopover(bool can_add_new, Gee.HashMap<string, T>? in_options = null)
    {
        options = new Gee.HashMap<string, T>();

        Box main_box = new Box(Orientation.VERTICAL, 6);
        main_box.margin = 12;

        Box search_box = new Box(Orientation.HORIZONTAL, 0);
        search_box.get_style_context().add_class("linked");
        search_entry = new SearchEntry();
        search_entry.search_changed.connect(update_search);

        ScrolledWindow tag_scroll = new ScrolledWindow(null, null);
        tag_scroll.get_style_context().add_class("frame");
        tag_scroll.hscrollbar_policy = PolicyType.NEVER;
        tag_scroll.min_content_width = 80;
        tag_scroll.min_content_height = 150;
        tag_list = new ListBox();
        tag_list.row_activated.connect(toggled);

        tag_list.set_sort_func(update_sort);
        tag_list.set_filter_func(update_filter);
        tag_list.set_header_func(listbox_header_separator);
        tag_list.selection_mode = SelectionMode.NONE;

        if(options != null)
            foreach(Gee.Map.Entry<string, T> entry in options.entries)
                add_option(entry.key, entry.value);

        this.add(main_box);
        main_box.add(search_box);
        search_box.pack_start(search_entry, true, true);
        if(can_add_new) {
            Button add_button = new Button.from_icon_name("list-add-symbolic");
            add_button.clicked.connect(handle_add);
            search_box.add(add_button);
        }

        main_box.add(tag_scroll);
        tag_scroll.add(tag_list);
    }

    protected CheckListEntry<T> add_option(string option, T data)
    {
        options[option] = data;
        CheckListEntry<T> check = new CheckListEntry<T>(option, data);
        tag_list.add(check);

        return check;
    }

    protected abstract T? create_item(string item);
    protected abstract void item_selected(CheckListEntry<T> entry);

    private void handle_add()
    {
        T? item = create_item(search_entry.text);
        if(search_entry.text.length != 0 && item != null)
            add_option(search_entry.text, item);
    }

    private void toggled(ListBox box, ListBoxRow row)
    {
        CheckListEntry? entry = row as CheckListEntry;
        if(entry == null)
            return;

        item_selected(entry);
    }

    private void update_search()
    {
        tag_list.invalidate_filter();
    }

    private bool update_filter(ListBoxRow child)
    {
        string filter_text = search_entry.text.strip().down();
        if(filter_text.length == 0) {
            return true;
        }

        CheckListEntry? entry = child as CheckListEntry;

        return entry == null || entry.title.down().contains(filter_text);
    }

    private int update_sort(ListBoxRow child1, ListBoxRow child2)
    {
        CheckListEntry? entry1 = child1 as CheckListEntry;
        CheckListEntry? entry2 = child2 as CheckListEntry;
        if(entry1 == null || entry2 == null)
            return 0;

        return intelligent_compare(entry1.title, entry2.title);
    }
}

public abstract class SingleSelectionPopover<T> : SelectionPopover<T>
{
    public SingleSelectionPopover(bool can_add_new, Gee.HashMap<string, T>? options = null)
    {
        base(can_add_new, options);
    }

    protected override void item_selected(CheckListEntry<T> item)
    {
        if(selected != item) {
            if(selected != null)
                selected.toggle();
            selected = item;
            selected.toggle();
            selection_changed(selected);
        }
    }

    protected abstract void selection_changed(CheckListEntry<T> new_item);

    protected CheckListEntry? selected;
}

public abstract class MultiSelectionPopover<T> : SelectionPopover<T>
{
    public MultiSelectionPopover(bool can_add_new, Gee.HashMap<string, T>? options = null)
    {
        base(can_add_new, options);
    }

    protected override void item_selected(CheckListEntry<T> item)
    {
        item.toggle();
        item_toggled(item);
    }

    protected abstract void item_toggled(CheckListEntry<T> item);
}

public void listbox_header_separator(Gtk.ListBoxRow row, Gtk.ListBoxRow? brow)
{
    if(brow != null && row.get_header() == null) {
        row.set_header(new Gtk.Separator(Gtk.Orientation.HORIZONTAL));
    }
}

public int intelligent_compare(string a, string b, bool unequal_lengths = false)
{
    int a1 = -1, a2 = -1, b1 = -1, b2 = -1;
    int i = 0;
    uint8[] adata = a.data;
    uint8[] bdata = b.data;
    int alen = a.length;
    int blen = b.length;
    for(i = 0; i < alen; ++i) {
        if(adata[i] >= '0' && adata[i] <= '9') {
            if(a1 == -1)
                a1 = i;
        } else if(a1 != -1) {
            a2 = i;
            break;
        }
    }
    if(a1 != -1 && a2 == -1)
        a2 = i;
    for(i = 0; i < blen; ++i) {
        if(bdata[i] >= '0' && bdata[i] <= '9') {
            if(b1 == -1)
                b1 = i;
        } else if(b1 != -1) {
            b2 = i;
            break;
        }
    }
    if(b1 != -1 && b2 == -1)
        b2 = i;

    if(a1 == -1 || b1 == -1 || a1 != b1)
        return strcmp(a, b);

    string aa = a.substring(0, a1);
    string bb = b.substring(0, b1);
    int first_part_res = aa.collate(bb);
    if(first_part_res != 0)
        return first_part_res;

    if(a2 - a1 != b2 - b1 && !unequal_lengths)
        return (a2 - a1) > (b2 - b1) ? 1 : 0;

    int ia = int.parse(a.substring(a1, a2 - a1));
    int ib = int.parse(b.substring(b1, b2 - b1));

    if(ia > ib)
        return 1;
    else if(ia == ib)
        return strcmp(a.substring(a2), b.substring(b2));
    else
        return -1;
}
