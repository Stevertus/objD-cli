
import 'dart:io';

void ensureDirExists(path){
  if(Directory(path).existsSync() == false) Directory(path).createSync(recursive: true);
}

Future<void> copyFile(String input,String output) async {
    dynamic path = output.split('\\');
    path = path.sublist(0,path.length - 1).join('/');
    ensureDirExists(path);
    var inputFile = File(input).openRead();
    var outputFile = File(output).openWrite();
    await outputFile.addStream(inputFile);
    await outputFile.flush();
    await outputFile.close();
    print("Generated: " + output);
    return;
}

Future<void> copyFolder(String input, String output) async {
    var entities = await Directory(input).list(recursive: true,followLinks: false).toList();
    await Future.wait(entities.map<Future>((FileSystemEntity entity) async {
        if(!(entity is File)) return;
        var path = entity.path.replaceFirst(input, "");
        return await copyFile(entity.path, output + path);
    }).toList());
    return;
}