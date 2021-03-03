import 'dart:io';
import 'package:watcher/watcher.dart';
import './run.dart' as run;

main(List args, String path) {
  if (args.length < 2) {
    print("Usage: serve <root file>");
    return;
  }

  if (path == null) path = ".";

  var watcher = DirectoryWatcher(path);

  print(
      "objD will now watch all your files in ${path} and generate the datapack itself");
  print("Type 'r' to generate the datapack manually");
  var myargs = args.sublist(0);
  run.main(args);

  // enable hotreload
  if (!myargs.contains("--full")) myargs.add("--hotreload");

  stdin.listen((d) {
    if (String.fromCharCodes(d) == "r\r\n") run.run(myargs);
  });

  watcher.events.listen((event) {
    print(event.path);

    if (event.path.split('.').last == "dart" &&
        !event.path.contains(".g.dart")) {
      print("File Change detected: ${event.path}");
      run.run(myargs);
    }
  });
}
