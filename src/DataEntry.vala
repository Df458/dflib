public abstract class DataEntry
{
    public uint? id          { get { return _id; } }
    public bool  is_inserted { get { return id != null; } }

    public DataEntry()
    {
        _id = null;
    }

    public DataEntry.from_record(SQLHeavy.Record r)
    {
        try {
            _id = r.fetch_int();
        } catch(SQLHeavy.Error e) {
            warning("Cannot init DataEntry from record: %s", e.message);
            _id = null;
        }
    }

    public abstract bool insert();
    public abstract bool update();
    public abstract bool remove();

    protected void set_id(uint new_id)
    {
        _id = new_id;
    }

    private uint? _id;
}
