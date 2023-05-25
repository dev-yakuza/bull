import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:bull/collections/pub_version.dart';

Future<void> main(List<String> arguments) async {
  final cmd = NoneTraceCommandRunner(
    "bull",
    "A collection of convenient and useful Command-Line interfaces for development.",
  )..addCommand(PubVersion());
  await cmd.run(arguments);
}

class NoneTraceCommandRunner extends CommandRunner {
  NoneTraceCommandRunner(super.executableName, super.description);

  @override
  Future<int> runCommand(ArgResults topLevelResults) async {
    try {
      return await super.runCommand(topLevelResults);
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return 64;
    }
  }
}
