// import the core of the framework:
import 'package:objd/core.dart';
// import the custom pack:
import './packs/starter_pack.dart';

void main(List<String> args) {
  createProject(
    Project(
      name: 'objD Quickstart',
      target: "../",             // path for where to generate the project
      generate: StarterPack(),  // The starting point of generation
    ),
    args
  );
}
