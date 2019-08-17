import 'package:objd_cli/cli/new.dart' as newprj;
import 'package:objd_cli/cli/run.dart' as run;
import 'package:objd_cli/cli/serve.dart' as serve;
import 'package:objd_cli/cli/server.dart' as server;
import 'package:args/args.dart';

ArgResults argResults;

main(List<String> arguments) {
  final ArgParser argParser = new ArgParser()
    ..addFlag('help',
        abbr: 'h', negatable: false, help: "Shows this help menu")
    ..addFlag('version',
        abbr: 'v', negatable: false, help: "Shows the objD CLI Version")
    ..addOption('source',
        abbr: 's', defaultsTo: ".", help: "Changes the source path")
    ..addOption('out', help: "Overrides the target location of the project")
    ..addFlag('hotreload',negatable: false, help: "Enables hotreload")
    ..addFlag('min',negatable: false, help: "This minifies the file amount by ignoring the mcmeta and tag files")
    ..addFlag('prod',abbr: "p",negatable: false, help: "This creates a production build of your project")
    ..addFlag('full',negatable: false, help: "Generates the full project(just for objd serve!).")
    ..addFlag('debug',abbr: "d",negatable: false, help: "Creates a debug file that assembles the files");
    
  argResults = argParser.parse(arguments);

  List<String> paths = argResults.rest;


  if (argResults['help'] || paths.isEmpty) return showHelp(argParser);

  switch (paths[0]) {
    case 'new': newprj.main(argResults,paths);
      break;
    case 'run': run.main(argResults.arguments);
      break;
    case 'serve': serve.main(argResults.arguments,argResults['source']);
      break;
    case 'server': server.main(argResults.arguments,argResults['source']);
      break;
    // case 'build': server.main(argResults.arguments,argResults['source']);
    //   break;

    default: showHelp(argParser);
  }
}

showHelp(ArgParser argParser){
print("""
** HELP **
Use objd [command] [args] or pub global run objd:[command] [args] to run commands

* new [project_name] - generates a new project from a boilerplate

* run [project_root] - builds the project

* serve [project_root] - watches the current directory to change and builds the project on change with hotreload

* server inject [jar_server] - injects a server into the cli to be able to run it

* server start - Starts the server with the current directory as world.

${argParser.usage}  
  """);
}