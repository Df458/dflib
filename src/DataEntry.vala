public abstract class DataEntry
{
    public int  id          { get { return _id; } }
    public bool is_inserted { get { return id != -1; } }

    public DataEntry()
    {
        _id = -1;
    }

    public DataEntry.from_record(SQLHeavy.Record r)
    {
        try {
            _id = r.fetch_int(r.field_index("id"));
            build_from_record(r);
        } catch(SQLHeavy.Error e) {
            warning("Cannot init DataEntry from record: %s", e.message);
            _id = -1;
        }
    }

    public abstract SQLHeavy.Query? insert(SQLHeavy.Queryable q);
    public abstract SQLHeavy.Query? update(SQLHeavy.Queryable q);
    public abstract SQLHeavy.Query? remove(SQLHeavy.Queryable q);
    protected abstract bool build_from_record(SQLHeavy.Record r);

    protected void set_id(int new_id)
    {
        _id = new_id;
    }

    private int? _id = -1;
}
