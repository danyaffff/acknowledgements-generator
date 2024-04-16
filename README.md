# Acknowledgements Generator

Strong-typed access to third-party library licenses.

## Features

- [x] Swift Package Manager support.
- [x] CocoaPods support.

## Motivation

Many apps have an acknowledgments section that contains licenses for third-party libraries. When the project grows and the number of dependencies increases, this section becomes difficult to maintain. Automation can help you deal with this much easier.

For example, you can generate a JSON/plist file that contains information about all licenses. However, this solution is not very convenient to be used in code, since it is necessary to decode this files in runtime.

On the other hand, you can generate a Swift code, but then you may faced with a problem that it is unclear how to add the generated file to Sources.

This library solves this problem by using the Build Tool Plug-in, the output of which can be automatically used as Sources of the target.

## How does it work?

Build Tool Plug-ins are powerful tools that help developers to run commands in build time. Moreover, its output files will be automatically added to target sources. Thus, we can write a command that searches for LICENSE files, generates Swift code from them, and writes to the file that will be linked to the target.

First, we should find where each dependency manager clones its third-party libraries. Swift Package Manager clones its dependencies to the `DerivedData/<Project_Directory>/SourcePackages/checkouts` directory; CocoaPods clones to the `Pods` directory.

Next, we should detect where these directories are located. If we use a CLI command, it will be very difficult to determine where the `DerivedData` is since an Xcode user can change the default location to any custom path. However, if we use a Build Tool Plug-in, it is possible to use an `executablePath` property from the provided context (plugins run inside the `DerivedData` directory). The `Pods` can be found by searching for the same directory where the `.xcodeproj` file is located.

After that, we need to go through all package directories, collect the license text, and create a Swift struct that describes an acknowledgment. To use proper formatting, it is possible to use a [swift-syntax](https://github.com/apple/swift-syntax.git) library.

Finally, we should write the generated code to the desired file and set this file as an output for our Build Tool Plug-in.

## Installation

### Swift Package Manager

#### Xcode project:

1. Go to Project Settings, open the "Project Dependencies" tab, click on "+", enter https://github.com/danyaffff/acknowledgements-generator.git to the search field, and click on "Add Package".
2. Select a desired target and click on "Add Package".
3. Go to selected target settings, open the "Build Phases" tab, unfold the "Run Build Tool Plug-ins" section, and click on "+".
4. Select the `AcknowledgementsGeneratorPlugin` from the `AcknowledgementsGenerator` package.

#### Swift package:

1. Add the following line into the `dependencies` list of your `Package.swift` file:

```swift
.package(url: "https://github.com/danyaffff/acknowledgements-generator.git", .upToNextMajor(from: "1.0.0"))
```

2. For each target that requires the plugin add the following line to the `plugins` list:

```swift
.plugin(name: "AcknowledgementsGeneratorPlugin", package: "AcknowledgementsGenerator")
```

## Requirements

- iOS 16
- macOS 13
- tvOS 16
- watchOS 9
- visionOS 1

## Usage

After adding the plugin, build your project and an `Acknowledgement` struct with the access to licenses will be generated and available in your code. This struct has the following format:

```swift
struct Acknowledgement: Sendable, Hashable {
	let name: String
	let license: String
}

extension Acknowledgement: CaseIterable {
	static let allCases: [Self] = [
		// Your acknowledgements list
	]
}

extension Acknowledgement {
	// Your acknowledgements declaration
}
```

- `name` property describes a package name.

- `license` property contains a full license text with the original formatting.

You can access all acknowledgements using `Acknowledgement.allCases` property or the specific one using `Acknowledgement.myAcknowledgement`.

## Lisence

AcknowledgementsGenerator is available under the [MIT License](https://github.com/danyaffff/acknowledgements-generator/blob/main/LICENSE)
