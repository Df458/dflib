using Gtk;

public class SettingsGrid : Grid
{
    private struct index_label_entry
    {
        int index;
        Widget label;
    }

    private int                                     column_count = 0;
    private Gee.ArrayList<Box>                      label_box_list;
    private Gee.ArrayList<Box>                      control_box_list;
    private Gee.HashMap<Widget, index_label_entry?> children;

    public SettingsGrid()
    {
        label_box_list   = new Gee.ArrayList<Box>();
        control_box_list = new Gee.ArrayList<Box>();
        children         = new Gee.HashMap<Widget, index_label_entry?>();

        this.row_spacing = 18;
        this.column_spacing = 12;
    }

    public new void add(string? label, Widget child, int section)
    {
        Label label_widget = new Label(label);

        label_widget.sensitive = child.sensitive;
        label_widget.halign = Align.END;

        while(section >= column_count)
        {
            Box label_box = new Box(Orientation.VERTICAL, 6);
            label_box.set_homogeneous(true);
            Box control_box = new Box(Orientation.VERTICAL, 6);
            control_box.set_homogeneous(true);
            label_box_list.add(label_box);
            control_box_list.add(control_box);

            this.attach(label_box, 0, column_count);
            this.attach(control_box, 1, column_count);

            ++column_count;
        }

        label_box_list[section].add(label_widget);
        control_box_list[section].add(child);

        index_label_entry entry = index_label_entry();
        entry.index = section;
        entry.label = label_widget;
        children.set(child, entry);
    }

    public new void add_custom(Widget label_widget, Widget child, int section)
    {
        label_widget.halign = Align.END;
        child.halign = Align.START;

        while(section >= label_box_list.size)
        {
            Box label_box = new Box(Orientation.VERTICAL, 6);
            label_box.set_homogeneous(true);
            Box control_box = new Box(Orientation.VERTICAL, 6);
            control_box.set_homogeneous(true);
            label_box_list.add(label_box);
            control_box_list.add(control_box);

            this.attach(label_box, 0, label_box_list.size - 1);
            this.attach(control_box, 1, control_box_list.size - 1);
        }

        label_box_list[section].add(label_widget);
        control_box_list[section].add(child);

        index_label_entry entry = index_label_entry();
        entry.index = section;
        entry.label = label_widget;
        children.set(child, entry);
    }

    public new void remove(Widget child)
    {
        index_label_entry entry = children.get(child);
        children.unset(child);
        label_box_list[entry.index].remove(entry.label);
        control_box_list[entry.index].remove(child);
    }
}
