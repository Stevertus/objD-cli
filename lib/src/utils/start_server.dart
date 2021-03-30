import 'dart:io';

void startServer(String path) {
  if (!File('$path\\run.jar').existsSync()) {
    return print('Server cannot start\nPlease inject a Server jar first!');
  }
  print('Starting the server . . .');
  Process.run('java -jar $path\\run.jar', [], workingDirectory: path)
      .then((result) {
    print('t');
    stdout.write(result.stdout);
    stderr.write(result.stderr);
  }).catchError((err) {
    print(err);
  });
  print('Please insert $path\\world\\datapacks as project target!');
}
