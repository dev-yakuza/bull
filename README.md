# Bull

A collection of convenient and useful Command-Line interfaces for development.

## Introduction

There are some commands when developing. This package is a collection of convenient and useful Command-Line interfaces for development.

## Installing

You can install this package by executing the following command.

```bash
dart pub add --dev bull
```

Or, open the `pubspec.yaml` file and add the `bull` package to dev_dependencies as follows.

```yaml
...
dev_dependencies:
  bull: [version]
...
```

Also, you can activate this package by the following command.

```yaml
dart pub global activate bull
```

## Commands

The `Bull` package the following commands.

- pub_version

### pub_version

The`pub_version` command updates the version in the `pubspec.yaml` file.

You can execute this like the followings.

```bash
# When you install by `dart pub add --dev bull`
dart run bull:pub_version --version patch

# When you install by `dart pub global activate bull`
dart pub global run bull:pub_version --version patch
```

This command supports the following options.

- `--version`: You can set `major`, `minor`, `patch`, `build` and the specific version like `2.7.5`.

## Contributing

If you want to contribute to this package, please see [CONTRIBUTING](CONTRIBUTING.md).
