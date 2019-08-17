import 'dart:io';


void main(List<String> args){

  if (args.length < 1) {
    print("Usage: run <root file>");
    return;
  }
  run(args);
}

Future run(List<String> args){
   var name = args[1];
  if(!name.contains(".dart")) name += ".dart";

  return Process.run('dart',[name,...args.sublist(2)]).then((ProcessResult results){
    print(results.stderr);
    print(results.stdout);
  });
}