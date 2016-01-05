# dflib
This library is designed to be used when making software with Gtk3 and Vala.
It might theoretically work with gobject C, given that Vala compiles to C code.

## Contents
Here's a quick description of the various classes and what they do:
### SettingsGrid
The SettingsGrid class is a structural widget designed for creating a simple 2-column form.
The resulting form is broken up into sections, denoted by space. By default, the left-hand column holds generated Labels with whatever text you specify, but you can replace it with a custom widget via add_custom().
