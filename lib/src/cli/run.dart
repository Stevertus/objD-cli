import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: run <root file>');
    return;
  }
  run(args);
}

Future run(List<String> args) async {
  assert(args.length > 1, 'Please provide the main file');
  var name = args[1];
  if (!name.contains('.dart')) name += '.dart';

  // run the build runner if --gen is present
  if (args.contains('--gen')) {
    await Process.run('pub', ['run', 'build_runner', 'build'], runInShell: true)
        .then((ProcessResult results) {
      print(results.stderr);
      print(results.stdout);
    });

    //args = args.where((a) => a != '--gen').toList();
  }

  return Process.run('dart', [name, ...args.sublist(2)])
      .then((ProcessResult results) {
    print(results.stderr);
    print(results.stdout);
  });
}
