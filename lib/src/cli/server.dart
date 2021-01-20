import 'dart:io';
import 'dart:isolate';

import 'package:objd_cli/src/utils/copy.dart';
import 'package:objd_cli/src/utils/run_command.dart';
import 'package:objd_cli/src/utils/start_server.dart';

main(List<String> args, String source) {
  Isolate.resolvePackageUri(Uri.parse("package:objd_cli/repl")).then((Uri res) {
    String server = res.toFilePath().replaceFirst("lib\\repl", "server");

    if (args.length < 2) return print("Usage: server [start | inject]");
    if (args[1] == "start") {
      if (source == null) source = ".";

      copyFolder(source, server + "\\world\\").then((_) {
        startServer(server);
      });

      stdin.listen((val) {
        try {
          runCommand(String.fromCharCodes(val).split("\r\n")[0]);
        } catch (err) {
          print(err);
        }
      });
    } else if (args[1] == "inject") {
      if (args.length < 3) return print("Usage: server inject [path]");
      if (!args[2].contains(".jar")) return print("Please inject a .jar file!");
      copyFile(args[2], server + "\\run.jar").then((_) {
        print("Injected ${args[2]} in the server");
      });
    }
  });
}
