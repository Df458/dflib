namespace DFLib {
public abstract class SimpleItem : Object
{
    public int id { get; construct; }
    public string name { get; construct; }

    public SimpleItem(int n_id, string n_name) { Object(id:n_id, name:n_name); }
    public SimpleItem.from_query(string type_name, SQLHeavy.QueryResult q)
    {
        int n_id;
        string n_name;
        try {
            n_name = q.fetch_string(q.field_index("name"));
            n_id   = q.fetch_int(q.field_index("id"));
        } catch(SQLHeavy.Error e) {
            stderr.printf("Error loading %s data: %s\n", type_name, e.message);
            return;
        }
        Object(id:n_id, name:n_name);
    }

    public SQLHeavy.Query save_query(SQLHeavy.Queryable qb) throws SQLHeavy.Error
    {
        StringBuilder builder = new StringBuilder("INSERT INTO ");
        builder.append_printf("%s (id, name) VALUES (%d, '%s')", get_table(), id, name.replace("\'", "\'\'"));
        SQLHeavy.Query q = new SQLHeavy.Query(qb, builder.str);
        return q;
    }

    public abstract string get_table();
}
}
