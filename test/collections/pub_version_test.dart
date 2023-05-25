import 'dart:io';

import 'package:run_with_print/run_with_print.dart';
import 'package:test/test.dart';

import '../../bin/bull.dart' as bull;

void main() {
  const tempFile = 'test/collections/temp.yaml';

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
    test('When version is major, update major version and reset others', () {
      runWithPrint((logs) async {
        expect(File(tempFile).readAsStringSync(), 'version: 2.5.7');
        await bull.main(
          ['pub_version', '--version', 'major', '--file-path', tempFile],
        );
        expect(File(tempFile).readAsStringSync(), 'version: 3.0.0');
        expect(logs[0], 'Update the version from 2.5.7 to 3.0.0...');

        await bull.main(
          ['pub_version', '--version', 'major', '--file-path', tempFile],
        );
        expect(File(tempFile).readAsStringSync(), 'version: 4.0.0');
        expect(logs[1], 'Update the version from 3.0.0 to 4.0.0...');
      });
    });

    test('When version is minor, update minor version and reset patch', () {
      runWithPrint((logs) async {
        expect(File(tempFile).readAsStringSync(), 'version: 2.5.7');
        await bull.main(
          ['pub_version', '--version', 'minor', '--file-path', tempFile],
        );
        expect(File(tempFile).readAsStringSync(), 'version: 2.6.0');
        expect(logs[0], 'Update the version from 2.5.7 to 2.6.0...');

        await bull.main(
          ['pub_version', '--version', 'minor', '--file-path', tempFile],
        );
        expect(File(tempFile).readAsStringSync(), 'version: 2.7.0');
        expect(logs[1], 'Update the version from 2.6.0 to 2.7.0...');
      });
    });

    test('When version is patch, update patch version and reset build', () {
      runWithPrint((logs) async {
        expect(File(tempFile).readAsStringSync(), 'version: 2.5.7');
        await bull.main(
          ['pub_version', '--version', 'patch', '--file-path', tempFile],
        );
        expect(File(tempFile).readAsStringSync(), 'version: 2.5.8');
        expect(logs[0], 'Update the version from 2.5.7 to 2.5.8...');

        await bull.main(
          ['pub_version', '--version', 'patch', '--file-path', tempFile],
        );
        expect(File(tempFile).readAsStringSync(), 'version: 2.5.9');
        expect(logs[1], 'Update the version from 2.5.8 to 2.5.9...');
      });
    });

    test('When version is build, update build version', () {
      runWithPrint((logs) async {
        expect(File(tempFile).readAsStringSync(), 'version: 2.5.7');
        await bull.main(
          ['pub_version', '--version', 'build', '--file-path', tempFile],
        );
        expect(File(tempFile).readAsStringSync(), 'version: 2.5.7+1');
        expect(logs[0], 'Update the version from 2.5.7 to 2.5.7+1...');

        await bull.main(
          ['pub_version', '--version', 'build', '--file-path', tempFile],
        );
        expect(File(tempFile).readAsStringSync(), 'version: 2.5.7+2');
        expect(logs[1], 'Update the version from 2.5.7+1 to 2.5.7+2...');
      });
    });

    test('When version is specific version, update version same as it', () {
      runWithPrint((logs) async {
        expect(File(tempFile).readAsStringSync(), 'version: 2.5.7');
        await bull.main(
          ['pub_version', '--version', '1.0.0', '--file-path', tempFile],
        );
        expect(File(tempFile).readAsStringSync(), 'version: 1.0.0');
        expect(logs[0], 'Update the version from 2.5.7 to 1.0.0...');

        await bull.main(
          ['pub_version', '--version', '2.7.7-dev.4', '--file-path', tempFile],
        );
        expect(File(tempFile).readAsStringSync(), 'version: 2.7.7-dev.4');
        expect(logs[1], 'Update the version from 1.0.0 to 2.7.7-dev.4...');
      });
    });

    group('Error occurs', () {
      test('If no version is passed', () {
        runWithPrint((logs) async {
          await bull.main(['pub_version', '--file-path', tempFile]);

          expect(logs[0], '[ERROR] The version option is required.');
        });
      });

      test('If wrong version is passed', () {
        runWithPrint((logs) async {
          await bull.main(
            ['pub_version', '--version', 'abcd', '--file-path', tempFile],
          );

          expect(
              logs[0],
              '''
[ERROR] abcd is not supported. The version must be
- major
- minor
- patch
- build
- specific version (ex: 2.5.7)
'''
                  .trim());
        });
      });

      test('If file does not exist in pubspec path', () {
        runWithPrint((logs) async {
          await bull.main([
            'pub_version',
            '--version',
            'major',
            '--file-path',
            'wrong_path.yaml',
          ]);

          expect(logs[0], '[ERROR] The "wrong_path.yaml" file does not exist.');
        });
      });

      test('If pubspec file does not have version option', () {
        runWithPrint((logs) async {
          final file = File(tempFile);
          file.writeAsStringSync('');

          await bull.main(
            ['pub_version', '--version', 'major', '--file-path', tempFile],
          );

          expect(
            logs[0],
            '[ERROR] The version option in "test/collections/temp.yaml" is not founded.',
          );
        });
      });
    });
  });
}
