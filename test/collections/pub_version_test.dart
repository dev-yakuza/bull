import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bull/collections/pub_version.dart';
import 'package:test/test.dart';

void main() {
  const tempFile = 'test/collections/temp.yaml';
  final runner = CommandRunner('test', 'test')..addCommand(PubVersion());

  setUp(() {
    final file = File(tempFile);
    if (file.existsSync() == false) File(tempFile).createSync();
    file.writeAsStringSync('version: 2.5.7');
  });

  tearDown(() {
    final file = File(tempFile);
    if (file.existsSync() == true) File(tempFile).deleteSync();
  });

  group('Update', () {
    test('When version is major, update major version and reset others',
        () async {
      expect(File(tempFile).readAsStringSync(), 'version: 2.5.7');
      await runner.run(
        ['pub_version', '--version', 'major', '--file-path', tempFile],
      );
      expect(File(tempFile).readAsStringSync(), 'version: 3.0.0');
      await runner.run(
        ['pub_version', '--version', 'major', '--file-path', tempFile],
      );
      expect(File(tempFile).readAsStringSync(), 'version: 4.0.0');
    });

    test('When version is minor, update minor version and reset patch',
        () async {
      expect(File(tempFile).readAsStringSync(), 'version: 2.5.7');
      await runner.run(
        ['pub_version', '--version', 'minor', '--file-path', tempFile],
      );
      expect(File(tempFile).readAsStringSync(), 'version: 2.6.0');
      await runner.run(
        ['pub_version', '--version', 'minor', '--file-path', tempFile],
      );
      expect(File(tempFile).readAsStringSync(), 'version: 2.7.0');
    });

    test('When version is patch, update patch version and reset build',
        () async {
      expect(File(tempFile).readAsStringSync(), 'version: 2.5.7');
      await runner.run(
        ['pub_version', '--version', 'patch', '--file-path', tempFile],
      );
      expect(File(tempFile).readAsStringSync(), 'version: 2.5.8');
      await runner.run(
        ['pub_version', '--version', 'patch', '--file-path', tempFile],
      );
      expect(File(tempFile).readAsStringSync(), 'version: 2.5.9');
    });

    test('When version is build, update build version', () async {
      expect(File(tempFile).readAsStringSync(), 'version: 2.5.7');
      await runner.run(
        ['pub_version', '--version', 'build', '--file-path', tempFile],
      );
      expect(File(tempFile).readAsStringSync(), 'version: 2.5.7+1');
      await runner.run(
        ['pub_version', '--version', 'build', '--file-path', tempFile],
      );
      expect(File(tempFile).readAsStringSync(), 'version: 2.5.7+2');
    });

    test('When version is specific version, update version same as it',
        () async {
      expect(File(tempFile).readAsStringSync(), 'version: 2.5.7');
      await runner.run(
        ['pub_version', '--version', '1.0.0', '--file-path', tempFile],
      );
      expect(File(tempFile).readAsStringSync(), 'version: 1.0.0');
      await runner.run(
        ['pub_version', '--version', '2.7.7-dev.4', '--file-path', tempFile],
      );
      expect(File(tempFile).readAsStringSync(), 'version: 2.7.7-dev.4');
    });

    group('Error occurs', () {
      test('If no version is passed', () async {
        try {
          await runner.run(['pub_version', '--file-path', tempFile]);
        } catch (e) {
          expect(e, '[ERROR] The version option is required.');
        }
      });

      test('If wrong version is passed', () async {
        try {
          await runner.run(
            ['pub_version', '--version', 'abcd', '--file-path', tempFile],
          );
        } catch (e) {
          expect(
              e,
              '''
[ERROR] abcd is not supported. The version must be
- major
- minor
- patch
- build
- specific version (ex: 2.5.7)
'''
                  .trim());
        }
      });

      test('If file does not exist in pubspec path', () async {
        try {
          await runner.run(
            [
              'pub_version',
              '--version',
              'major',
              '--file-path',
              'wrong_path.yaml',
            ],
          );
        } catch (e) {
          expect(e, '[ERROR] The "wrong_path.yaml" file does not exist.');
        }
      });

      test('If pubspec file does not have version option', () async {
        try {
          final file = File(tempFile);
          file.writeAsStringSync('');

          await runner.run(
            ['pub_version', '--version', 'major', '--file-path', tempFile],
          );
        } catch (e) {
          expect(
            e,
            '[ERROR] The version option in "test/collections/temp.yaml" is not founded.',
          );
        }
      });
    });
  });
}
