# objD CLI

The objD CLI is an additional package to handle execution, building and deploying of your project. To activate the global package(will be available anywhere on your system), run this command:
```
pub global activate objd_cli
```
This will add the commands to your console.
To run a command run:  
```
objd [command] [args]
```
OR
```
pub global run objd:[command] [args]
```
> If the objd command is not available, you have to add the pub cache to your system path. Follow this tutorial: [https://www.dartlang.org/tools/pub/cmd/pub-global#running-a-script-from-your-path](https://www.dartlang.org/tools/pub/cmd/pub-global#running-a-script-from-your-path)



## Commands
* **help** - opens a help menu with all commands
* **new** [project_name] - generates a new project from a boilerplate
* **run** [project_root] - builds one project
* **serve** [directory] [project_root] - watches the directory to change and builds the project on change
* **server inject** [jar-file] - injects a server file(use bukkit with plugins to reload automatically) before starting the server(The file is not included in the package due to legal reasons)
* **server start** [world_dir] - copies the world into the server directory and starts the server

## Build Options
You can use certain arguments to pass options to the build methods.
This argument list can directly be edited in createProject:
```dart
createProject(
	Project(...),
	["arg1","arg2", ... ] // arguments as optional List
)
```
**OR** (what I recommend) you can just take the program arguments from main:
```dart
void main(List<String> args) {
  createProject(
    Project(...),
    args
  );
}
```
This allows you to use the arguments in the execution command, like:
* ```dart index.dart arg1 --min``` 
* ```objd run index.dart arg1 --min``` 
* ```objd serve . index.dart --min``` 

**All Available Arguments:**
* `--hotreload`: Saves the state of your project and compares just the latest changes.
* `--full`: Generates the full project(just for objd serve!).
* `--min`: This minifies the file amount by ignoring the mcmeta and tag files
* `--prod`: This creates a production build of your project and saves it into another datapack(`(prod)` added).
In Production Comments and line breaks are removed and every widget can access the prod value in Context to get notified.
* `--debug`: This creates a debug json file in your project root, that lists all properties and other generated files

## Hotreload
The hotreload option is an experimental feature, that just looks at the things you changed since the last build. This can improve performance significantly especially for big projects with many generated mcfunctions.

This feature is enabled by default for `objd serve`, if you include the args.
You can disable it with the `-full` option.

**How it works:**

objD saves a representation of your project in the objd.json file of your project.
For each new build or reload it checks which parts of the project you changed and just generates the new necessary files to implement your change in the datapack.