using Gee;

namespace DFLib {
    public class PathHelpers {
        /** Get the file extension of the given path
         *
         * @param path The filepath
         */
        public static string get_extension (string path) {
            // Add 2: 1 for skipping the /, and one for skipping a leading .
            int name_index = path.last_index_of_char ('/') + 2;

            if (name_index < path.length) {
                int index = path.index_of_char ('.', name_index);
                if (index != -1) {
                    return path.substring (index);
                }
            }

            return "";

        }

        /** Get a list of paths pointing to child files of the given directory path
         *
         * As the name implies, this will only return files, not directories.
         *
         * @param path The path to check
         */
        public static Collection<string> get_child_files (string path) {
            var files = new ArrayList<string> ();

            var dir = File.new_for_path (path);

            if (!dir.query_exists ()) {
                return files;
            }

            try {
                FileEnumerator enumerator = dir.enumerate_children("standard::*", 0);

                for (FileInfo file_info = enumerator.next_file();
                        file_info != null;
                        file_info = enumerator.next_file()) {
                    if(file_info.get_file_type() != FileType.DIRECTORY) {
                        File file = enumerator.get_child (file_info);
                        files.add (file.get_path ());
                    }
                }
                enumerator.close();
            } catch (GLib.Error e) {
                warning ("Failed to scan directory %s: %s", path, e.message);
            }

            return files;
        }
    }
}
