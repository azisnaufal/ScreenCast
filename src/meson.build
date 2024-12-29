screencast_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
  'window_view.vala',
  'window_controller.vala',
]

screencast_deps = [
  config_dep,
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('libportal'),
  dependency('libportal-gtk4'),
]

blueprints = custom_target ('blueprints',
  input: files (
    'window.blp',
  ),
  output: '.',
  command: [ find_program ('blueprint-compiler'), 'batch-compile', '@CURRENT_SOURCE_DIR@', '@CURRENT_SOURCE_DIR@', '@INPUT@' ],
)

screencast_sources += gnome.compile_resources('screencast-resources',
  'screencast.gresource.xml',
  c_name: 'screencast',
  dependencies: blueprints,
)

executable('screencast', [screencast_sources],
  dependencies: screencast_deps,
  include_directories: config_inc,
       install: true,
)
