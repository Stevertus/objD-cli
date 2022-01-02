import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';

import 'package:args/args.dart';
import 'package:http/http.dart' as http;

const Templates = {
  'basic - the barebones objD project using Dart Annotations': 'basic',
  'classic - the more familiar old objD style without any code generators':
      'classic',
  'click - a basic carrot on a stick clicker example': 'click'
};

final URI = Uri.http('api.github.com', 'repos/Stevertus/objd-templates/git/');

String readLineOr(String msg, String def) {
  print(msg.replaceAll('[]', '[$def]'));
  final l = stdin.readLineSync();
  return l != null && l.isNotEmpty ? l : def;
}

void createNew(ArgResults args, List<String> paths) {
  if (paths.length < 2) return print('Usage: new <name>');
  print('setting up new project...');
  final name = paths[1];

  var datapack = readLineOr('Datapack name: []', name + ' DP');
  var namespace = readLineOr(
    'Datapack namespace: []',
    name.toLowerCase().replaceAll(RegExp(r'\s+'), '_'),
  );
  var template = Templates.keys.first;
  int? tIndex;
  do {
    tIndex = int.tryParse(readLineOr(
      'Select Project Template: []\n' +
          Templates.keys.mapIndexed((i, k) => '${i + 1}) $k').join('\n'),
      '1',
    ));
    if (tIndex == null) print('Please enter a number');
  } while (tIndex == null || tIndex > Templates.length || tIndex < 1);
  template = Templates.keys.toList()[tIndex - 1];

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
          .replaceAll('%namespace%', namespace)
          .replaceAll('%project%', datapack);
      await file.writeAsString(content);
      print('Cloned $path');
    }
  }

  void cloneFolder(String sha) async {
    print('Cloning Project...');
    final body = await http
        .get(URI.resolve('trees/main?recursive=1'))
        .then((res) => json.decode(res.body));
    if (body != null && body['tree'] != null) {
      final tree = body['tree'];
      for (var t in tree) {
        if (t['type'] == 'blob' && (t['path'] as String).contains(sha)) {
          cloneFile('./$name/${t['path']}'.replaceAll('$sha/', ''),
              t['url'] as String);
        }
      }
    }
  }

  cloneFolder(Templates[template]!);

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
