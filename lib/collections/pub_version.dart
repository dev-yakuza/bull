import 'dart:io';

import 'package:args/command_runner.dart';

class PubVersion extends Command {
  @override
  final name = 'pub_version';

  @override
  final description = 'updates the version in the "pubspec.yaml" file.';

  PubVersion() {
    argParser
      ..addOption(
        'version',
        help:
            'New version for updating. You can pass "major", "minor", "patch", "build" and specific version("2.7.10")',
      )
      ..addOption('file-path', help: 'Custom pubspec.yaml file path.');
  }

  @override
  void run() {
    String? version = argResults?['version'];
    String pubspecPath = argResults?['file-path'] ?? 'pubspec.yaml';

    _isValidate(version: version, pubspecPath: pubspecPath);

    final oldVersion = _extractVersionFromPubspecFile(pubspecPath);
    final newVersion = _getNewVersion(
      oldVersion: oldVersion,
      version: version!,
    );

    // ignore: avoid_print
    print('Update the version from $oldVersion to $newVersion...');
    _updateVersionInPubspecFile(
      oldVersion: oldVersion,
      newVersion: newVersion,
      pubspecPath: pubspecPath,
    );
  }

  void _isValidate({String? version, required String pubspecPath}) {
    if (version == null) {
      throw '[ERROR] The version option is required.';
    }

    final exp = RegExp(r'[0-9]+.[0-9]+.[0-9]+.*');
    final match = exp.firstMatch(version);
    if (['major', 'minor', 'patch', 'build'].contains(version) == false &&
        match == null) {
      throw '''
[ERROR] $version is not supported. The version must be
- major
- minor
- patch
- build
- specific version (ex: 2.5.7)
'''
          .trim();
    }

    if (File(pubspecPath).existsSync() == false) {
      throw '[ERROR] The "$pubspecPath" file does not exist.';
    }
  }

  String _extractVersionFromPubspecFile(String pubspecPath) {
    final file = File(pubspecPath);
    final yaml = file.readAsStringSync();

    final exp = RegExp(r'version: [0-9]+.[0-9]+.[0-9]+.*');
    final match = exp.firstMatch(yaml);
    if (match == null) {
      throw '[ERROR] The version option in "$pubspecPath" is not founded.';
    }

    return match[0]!.split(': ')[1];
  }

  void _updateVersionInPubspecFile({
    required String oldVersion,
    required String newVersion,
    required String pubspecPath,
  }) {
    final file = File(pubspecPath);
    final yaml = file.readAsStringSync();

    file.writeAsStringSync(
      yaml.replaceFirst('version: $oldVersion', 'version: $newVersion'),
    );
  }

  String _getNewVersion({
    required String oldVersion,
    required String version,
  }) {
    final versions = oldVersion.split('.');
    var major = int.parse(versions[0]);
    var minor = int.parse(versions[1]);

    final subVersion = versions[2].split('+');
    var patch = int.parse(subVersion[0]);
    var build = subVersion.length > 1 ? int.parse(subVersion[1]) : null;

    switch (version) {
      case 'major':
        major += 1;
        minor = 0;
        patch = 0;
        build = null;
        break;
      case 'minor':
        minor += 1;
        patch = 0;
        build = null;
        break;
      case 'patch':
        patch += 1;
        build = null;
        break;
      case 'build':
        if (build == null) {
          build = 1;
          break;
        }
        build += 1;
        break;
      default:
        return version;
    }

    return '$major.$minor.$patch${build != null ? '+$build' : ''}';
  }
}
