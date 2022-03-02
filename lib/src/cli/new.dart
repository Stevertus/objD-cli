import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';

import 'package:args/args.dart';
import 'package:http/http.dart' as http;

final URI = Uri.http('api.github.com', 'repos/Stevertus/objd-templates/git/');

String readLineOr(String msg, String def) {
  print(msg.replaceAll('[]', '[$def]'));
  final l = stdin.readLineSync();
  return l != null && l.isNotEmpty ? l : def;
}

int readIntOr(String msg, int def, {int? max, int min = 0}) {
  int? val;
  do {
    val = int.tryParse(readLineOr(
      msg,
      def.toString(),
    ));
    if (val == null) print('Please enter a number');
  } while (val == null || (max != null && val > max) || val < min);
  return val;
}

void createNew(ArgResults args, List<String> paths) async {
  if (paths.length < 2) return print('Usage: new <name>');
  final name = paths[1];
  print('setting up new project $name...');
  print(
    'Welcome to the objD setup Wizard! To create a project, please answer following questions or accept the [default]:',
  );

  var datapack = readLineOr('Datapack name: []', name + ' DP');
  var namespace = readLineOr(
    'Datapack namespace: []',
    name.toLowerCase().replaceAll(RegExp(r'\s+'), '_'),
  );

  // Fetch all available Templates
  final templateBody = await http
      .get(URI.resolve('trees/main'))
      .then((res) => json.decode(res.body));
  final templates = <String, String>{};

  for (final t in templateBody['tree'] ?? []) {
    if (t['type'] == 'tree') {
      templates[t['path'] as String] = t['sha'] as String;
    }
  }

  var template = templates.keys.first;
  int tIndex = readIntOr(
    'Select Project Template: []\n' +
        templates.keys.mapIndexed((i, k) => '${i + 1}) $k').join('\n'),
    1,
    max: templates.length,
    min: 1,
  );
  template = templates.keys.toList()[tIndex - 1];

  // Target Minecraft Version
  int version = readIntOr(
    'Target Minecraft Version: []\n',
    18,
    max: 25,
    min: 8,
  );

  void cloneFile(String path, String sourceUrl) async {
    final body = await http.get(Uri.parse(sourceUrl)).then(
          (res) => json.decode(res.body),
        );
    if (body != null && body['content'] != null) {
      final dir = path.split('/');
      dir.removeLast();
      if (!await Directory(dir.join('/')).exists()) {
        await Directory(dir.join('/')).create(recursive: true);
      }

      final file = File(path.replaceAll('%namespace%', namespace));
      final contentB64 = body['content'] as String;
      final bytes = base64.decode(contentB64.replaceAll('\n', ''));
      final content = (utf8.decode(bytes))
          .replaceAll(
            '%Namespace%',
            namespace[0].toUpperCase() +
                namespace.substring(1).replaceAll('_', ''),
          )
          .replaceAll('%namespace%', namespace)
          .replaceAll('%project%', datapack)
          .replaceAll('%version%', version.toString());
      await file.writeAsString(content);
      print('Cloned $path');
    }
  }

  void cloneFolder(String sha) async {
    print('Cloning Project...');
    final body = await http
        .get(URI.resolve('trees/$sha?recursive=1'))
        .then((res) => json.decode(res.body));
    if (body != null && body['tree'] != null) {
      final tree = body['tree'];
      for (var t in tree) {
        if (t['type'] == 'blob') {
          cloneFile('./$name/${t['path']}', t['url'] as String);
        }
      }
    }
  }

  cloneFolder(templates[template]!);

  Process.run('dart', ['pub get']);

  // Isolate.resolvePackageUri(Uri.parse('package:objd_cli/src')).then((Uri? res) {
  //   if (res == null) return;
  //   print(res);
  //   final server = res.toFilePath().replaceFirst('lib\\src', 'create');

  //   copyFolder(server, Directory.current.path + '/${paths[1]}', true).then(
  //     (_) => print('Created new project'),
  //   );
  // });
}
