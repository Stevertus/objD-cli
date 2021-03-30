import 'dart:io';
import 'dart:isolate';

import 'package:args/args.dart';
import 'package:objd_cli/src/utils/copy.dart';

void createNew(ArgResults args, List<String> paths) {
  if (paths.length < 2) return print('Usage: new <name>');

  Isolate.resolvePackageUri(Uri.parse('package:objd_cli/src')).then((Uri? res) {
    if (res == null) return;
    print(res);
    final server = res.toFilePath().replaceFirst('lib\\src', 'create');

    copyFolder(server, Directory.current.path + '/${paths[1]}', true).then(
      (_) => print('Created new project'),
    );
  });
}
