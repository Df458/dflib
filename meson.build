project('dflib', ['vala', 'c'],
        version : '0.1',
        license : 'GPLv3')

gnome = import('gnome')
pkgconfig = import('pkgconfig')

glib = dependency('glib-2.0')
gobject = dependency('gobject-2.0')
gee = dependency('gee-0.8')
gtk = dependency('gtk+-3.0')
sqlheavy = dependency('sqlheavy-0.1')

deps = [glib, gobject, gee, gtk, sqlheavy]

subdir('src')

meson.add_install_script('install.sh')

h = ['.'] # subdirectories of ${prefix}/${includedir} to add to header path
pkgconfig.generate(libraries : ['-L/usr/local/lib', '-ldflib'],
             subdirs : h,
             version : '0.1',
             name : 'dflib',
             filebase : 'dflib',
             description : 'A helper library for GTK3 applications')