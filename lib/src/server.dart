import 'package:objd_cli/src/utils/run_command.dart';

/// Send a command to the objD development server
void sendCommand(String cmd, {String url = 'localhost:9090'}) {
  runCommand(cmd, url: url);
}

void reloadServer({String url = 'localhost:9090'}) {
  runCommand('datapack disable "file/bukkit"', url: url);
  runCommand('datapack enable "file/bukkit"', url: url);
  runCommand(
      'tellraw @a [{"text":"Server was reloaded automatically by objD","color":"dark_aqua"}]',
      url: url);
  print('Reloading Development Server...');
}
