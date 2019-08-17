import 'dart:io';
import 'dart:isolate';

import 'package:args/args.dart';
import 'package:objd_cli/utils.dart/copy.dart';

main(ArgResults args, List<String> paths) {
  if (paths.length < 2) return print("Usage: new <name>");

  Isolate.resolvePackageUri(Uri.parse("package:objd_cli/repl")).then((Uri res){
    String server = res.toFilePath().replaceFirst("lib\\repl", "create");

    copyFolder(server, Directory.current.path + '/${paths[1]}').then((_) => print("done"));

  });
}