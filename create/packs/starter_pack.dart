import 'package:objd/core.dart';
// import all the files:
import '../files/load.dart';
import '../files/main.dart';

class StarterPack extends Widget {
  
  /// There is a folder for all packs inside a project, It is recommended to give each pack an own widget
  StarterPack();


  @override
  Widget generate(Context context) {
    return Pack(
      name: 'objdstart',  // name of the subpack TODO: Replace name
      main: File(         // definining a file that runs every tick
        path: 'main',
        child: MainFile()
      ),
      load: File(         // definining a file that runs on reload
        path: 'load',
        child: LoadFile()
      ),
      modules: [

      ],
      files: [
        
      ]
    );
  }
}
