// swift-tools-version: 5.10
//
//  Package.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 09.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import PackageDescription

let package = Package(
	name: "AcknowledgementsGenerator",
	platforms: [
		.iOS(.v16),
		.macOS(.v13),
		.tvOS(.v16),
		.watchOS(.v9),
		.visionOS(.v1)
	],
	products: [
		.executable(
			name: "acknowledgements-generator",
			targets: ["acknowledgements-generator"]
		),
		.plugin(
			name: "AcknowledgementsGeneratorPlugin",
			targets: ["AcknowledgementsGeneratorPlugin"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")
	],
	targets: [
		.executableTarget(
			name: "acknowledgements-generator",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.target(name: "AcknowledgementsCommon"),
				.target(name: "AcknowledgementsReader"),
				.target(name: "AcknowledgementsGenerator"),
				.target(name: "AcknowledgementsWriter")
			]
		),
		.plugin(
			name: "AcknowledgementsGeneratorPlugin",
			capability: .buildTool(),
			dependencies: [
				.target(name: "acknowledgements-generator")
			]
		),
		.target(
			name: "AcknowledgementsCommon"
		),
		.target(
			name: "AcknowledgementsReader",
			dependencies: [
				.target(name: "AcknowledgementsCommon")
			]
		),
		.target(
			name: "AcknowledgementsGenerator",
			dependencies: [
				.product(name: "SwiftSyntax", package: "swift-syntax"),
				.product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
				.target(name: "AcknowledgementsCommon")
			]
		),
		.target(
			name: "AcknowledgementsWriter",
			dependencies: [
				.target(name: "AcknowledgementsCommon")
			]
		)
	]
)
