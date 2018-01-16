public string resource_to_string(string resource_uri) throws GLib.Error {
    File resource_file = File.new_for_uri(resource_uri);
    FileInputStream stream = resource_file.read();
    DataInputStream data_stream = new DataInputStream(stream);

    StringBuilder builder = new StringBuilder();
    string? str = data_stream.read_line();
    do {
        builder.append(str + "\n");
        str = data_stream.read_line();
    } while(str != null);

    data_stream.close();

    return builder.str;
}
