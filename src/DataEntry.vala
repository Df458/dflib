using SQLHeavy;

namespace DFLib {
    public abstract class DataEntry : Object {
        public int id { get { return _id; } }
        public bool is_inserted { get { return id != -1; } }

        public DataEntry()
        {
            _id = -1;
        }

        public DataEntry.from_record(Record r)
        {
            try {
                _id = r.fetch_int(r.field_index("id"));
                build_from_record(r);
            } catch(SQLHeavy.Error e) {
                warning("Cannot init DataEntry from record: %s", e.message);
                _id = -1;
            }
        }

        /** Creates a query for inserting this entry
         *
         * @param q The Queryable to run this query against
         */
        public virtual Query? insert(Queryable q) throws SQLHeavy.Error {
            return null;
        }

        /** Creates a query for updating this entry
         *
         * @param q The Queryable to run this query against
         */
        public virtual Query? update(Queryable q) throws SQLHeavy.Error {
            return null;
        }

        /** Creates a query for removing this entry
         *
         * @param q The Queryable to run this query against
         */
        public virtual Query? remove(Queryable q) throws SQLHeavy.Error {
            return null;
        }

        /** Updates data after a successful insertion
         *
         * @param db The database that this was inserted into
         */
        public virtual void post_insert (Database db) {
            _id = (int)db.last_insert_id; // TODO
        }

        /** Populate data from a database record
         *
         * @param r The record to read
         */
        protected abstract void build_from_record(Record r) throws SQLHeavy.Error;

        protected void set_id(int new_id) {
            _id = new_id;
        }

        private int _id = -1;
    }

    public abstract class DataEntryGuid : Object {
        public string guid          { get { return _guid; } }
        public bool is_inserted { get { return guid != null; } }

        public DataEntryGuid()
        {
        }

        public DataEntryGuid.from_record(Record r)
        {
            try {
                _guid = r.fetch_string(r.field_index("guid"));
                build_from_record(r);
            } catch(SQLHeavy.Error e) {
                warning("Cannot init DataEntry from record: %s", e.message);
                _guid = null;
            }
        }

        /** Creates a query for inserting this entry
         *
         * @param q The Queryable to run this query against
         */
        public virtual Query? insert(Queryable q) throws SQLHeavy.Error {
            return null;
        }

        /** Creates a query for updating this entry
         *
         * @param q The Queryable to run this query against
         */
        public virtual Query? update(Queryable q) throws SQLHeavy.Error {
            return null;
        }

        /** Creates a query for removing this entry
         *
         * @param q The Queryable to run this query against
         */
        public virtual Query? remove(Queryable q) throws SQLHeavy.Error {
            return null;
        }

        /** Populate data from a database record
         *
         * @param r The record to read
         */
        protected abstract void build_from_record(Record r) throws SQLHeavy.Error;

        protected void set_guid(string new_guid) {
            _guid = new_guid;
        }

        private string _guid = null;
    }
}
