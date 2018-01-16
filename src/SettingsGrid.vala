using Gtk;

namespace DFLib
{
public class SettingsEntry : Box
{
    public Widget? title;
    public Widget  control;

    public SettingsEntry(string? new_title, Widget new_control)
    {
        if(new_title != null) {
            title = new Label(new_title);
            pack_start(title);
        }
        pack_end(new_control);
    }

    public SettingsEntry.custom(Widget? new_title, Widget new_control)
    {
        title = new_title;

        if(title != null)
            pack_start(title);
        pack_end(new_control);
    }
}

public class SettingsList : Box
{
    public SettingsList()
    {
        list = new ListBox();
        pack_start(list);
    }

    public new void add(string? label, Widget child)
    {
        if(entry_map.has_key(child)) {
            warning("SettingsList: Tried to add a child that already exists!");
            return;
        }
        SettingsEntry entry = new SettingsEntry(label, child);
        entry_map.set(child, entry);
        list.add(entry);
    }

    public new void add_custom(Widget? label, Widget child)
    {
        if(entry_map.has_key(child)) {
            warning("SettingsList: Tried to add a child that already exists!");
            return;
        }
        SettingsEntry entry = new SettingsEntry.custom(label, child);
        entry_map.set(child, entry);
        list.add(entry);
    }

    public new void remove(Widget child)
    {
        list.remove(entry_map.get(child));
    }

    private ListBox list;
    private Gee.HashMap<Widget, SettingsEntry> entry_map;
}
}
