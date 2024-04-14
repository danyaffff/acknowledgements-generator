//
//  AcknowledgementsGeneratorPlugin.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 09.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import Foundation
import PackagePlugin

@main
struct AcknowledgementsGeneratorPlugin {
	
	// MARK: - Internal methods
	
	func createBuildCommands(context: PluginContextProtocol) throws -> [Command] {
		try [
			.buildCommand(
				displayName: "AcknowledgementsGenerator: Generate Swift code from LICENSE files.",
				executable: context.executablePath,
				arguments: [
					"--input", try context.swiftPackageManagerInputPath,
					"--input", context.cocoaPodsInputPath,
					"--output", context.outputPath
				],
				outputFiles: [
					context.outputPath
				]
			)
		]
	}
}

// MARK: - BuildToolPlugin

extension AcknowledgementsGeneratorPlugin: BuildToolPlugin {
	
	// MARK: - Internal methods
	
	func createBuildCommands(
		context: PluginContext,
		target: any Target
	) async throws -> [PackagePlugin.Command] {
		try createBuildCommands(context: context)
	}
}

#if canImport(XcodeProjectPlugin)

// MARK: - XcodeBuildToolPlugin

import XcodeProjectPlugin

extension AcknowledgementsGeneratorPlugin: XcodeBuildToolPlugin {
	
	// MARK: - Internal methods
	
	func createBuildCommands(
		context: XcodePluginContext,
		target: XcodeTarget
	) throws -> [PackagePlugin.Command] {
		try createBuildCommands(context: context)
	}
}

#endif
