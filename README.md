<h1 align="center">Notarize</h1>
<p align="center">Command line tool to easily notarize a Mac app</p>
<p align="center">
    <img src="https://badgen.net/github/release/Mortennn/Notarize/stable?label=Release&color=black" alt="latest">
    <img src="https://badgen.net/badge/Swift/4.2/black" alt="swift4.2">
    <img src="https://badgen.net/badge/Platform/macOS/black" alt="platform">
    <img src="https://badgen.net/badge/License/MIT/black" alt="license">
</p>
<br><br>
Apple recently added a new service where they will check and approve an app to not execute malcious code. It is a great security improvement, but the downside is that this adds a new step in the build system.

This project is created to make it easy to automate this process.

## Installation
1. Download the [latest release](https://github.com/Mortennn/Notarize/releases/latest)
2. Run the install script: `$ ./install.sh`

## Usage

### Example
```
$ notarize \
    --package "~/path/to/app.dmg" \
    --username "mail@icloud.com" \
    --password "@keychain:AC_PASSWORD" \
    --primary-bundle-id "com.company.appname.dmg"
```

### Description
```
$ notarize --help

    Copyright (c) 2019, Morten Nielsen.

    Version: Notarize 1.0.0 NotarizeKit 1.0.0

    Usage: --package <path> --username <username> --password <password> --primary-bundle-id <primary-bundle-id>

    Options:

    --package            Path to either DMG or zip file.
    --username           Email associated with Apple Connect.
    --password           Password for Apple Connect. Can be plain text, but it is recommended to use "@keychain:<name>".
    --primary-bundle-id  Bundle id of package. e.g. "com.company.appName.dmg".
    --asc-provider       Specify asc provider.

    --help               Display options.

```

## What does it actually do?
1. Uses `$ xcrun altool` to upload the app package to Apple's servers.
2. Waits for the app to be notarized. Checks every 30 seconds.
3. Staples the app package with the generated certificate using `$ xcrun stapler staple <path>`

## FAQ

* Notarize says the package is invalid?
    * Notarize will print a UUID, which you can use to see the error log from Apple. The error log can be seen using `$ xcrun altool --notarization-info`

## License
MIT © [Morten Nielsen](https://github.com/Mortennn)
