using SQLHeavy;

namespace DFLib
{
public abstract class DatabaseRequest
{
    public enum Priority {
        INVALID = -1,
        LOW,
        MEDIUM,
        HIGH,
        COUNT,
        DEFAULT = LOW
    }

    public enum Status {
        COMPLETED = 0,
        FAILED,
        CONTINUE,
        COUNT,
        DEFAULT = COMPLETED
    }

    public abstract Query build_query(Queryable qb) throws SQLHeavy.Error;
    public abstract Status process_result(QueryResult qr) throws SQLHeavy.Error;
    public signal void processing_complete(bool success);
}

public abstract class RequestProcessor
{
    protected Database db;
    protected AsyncQueue<DatabaseRequest> requests[3];
    protected Thread<void*> processing_thread;

    public RequestProcessor(string path)
    {
        try {
            db = new Database(path);
            if(db.schema_version == 0) {
                info("Initializing database\u2026");
                init_schema(db);
            }

            while(update_schema_version(db));
        } catch(SQLHeavy.Error e) {
            error("Failed to initialize the database at %s: %s", path, e.message);
        }

        requests = {
            new AsyncQueue<DatabaseRequest>(),
            new AsyncQueue<DatabaseRequest>(),
            new AsyncQueue<DatabaseRequest>(),
        };
        processing_thread = new Thread<void*>(null, process);
    }

    public signal void query_complete(DatabaseRequest req, bool success = true);

    private void* process()
    {
        while(true) {
            DatabaseRequest req = requests[0].pop();
            DatabaseRequest.Status status = DatabaseRequest.Status.CONTINUE;
            do {
                Query q = null;
                try {
                    q = req.build_query(db);
                    QueryResult res = q.execute();
                    status = req.process_result(res);
                } catch(SQLHeavy.Error e) {
                    warning("Failed to process request: %s. Query is [%s]", e.message, q != null ? q.sql : "undefined");
                    break;
                }
            } while(status == DatabaseRequest.Status.CONTINUE);

            req.processing_complete(status == DatabaseRequest.Status.COMPLETED);
        }
    }

    public abstract void init_schema(Database db);

    public abstract bool update_schema_version(Database db);
}
}
