# Welcome to Bull contributing guide

Thank you for your interest in contributing to Bull! There are a few things you need to know to contribute.

## Lefthook

This project uses `Lefthook` to use Git hooks.

- Lefthook: [https://github.com/evilmartians/lefthook](https://github.com/evilmartians/lefthook)

So, If you want to contribute to this project, please install it to refer to the following link.

- Install lefthook: [https://github.com/evilmartians/lefthook/blob/master/docs/install.md](https://github.com/evilmartians/lefthook/blob/master/docs/install.md)

And then, execute the following command to configure Git hooks.

```bash
lefthook install
# npx lefthook install
```

This Git hooks will run `dart format`, `lint`, and `test`.

## Develop

The main codes are in the `lib/collections` folder. If you have any good idea or code, please modify it.

The `bin` folder is a wrapper for the features of the `lib/collections` folder. If you want your code for working as the CLI, please modify this, too.

The `test/collections` folder is the test code of the package. If you have any changes of the code, please add the test code about it in here.

## Commit message

Please add one of the following commit type to the commit message.

- `fix:`: In case of bug fixed.
- `feat:`: In case of feature added.
- `build:`: In case of build system or dependencies changed.
- `chore:`: In case of build system or dependencies changed.
- `ci:`: In case of CI configuration or scripts changed.
- `docs:`: In case of only documentation changed.
- `style:`: In case of code style(space, formatting, colons, etc) changed.
- `refactor:`: In case of refactoring code not fixing bugs or adding features.
- `pref:`: In case of modifying code for improving performance.
- `test:`: In case of adding test code or modifying existing test code.
