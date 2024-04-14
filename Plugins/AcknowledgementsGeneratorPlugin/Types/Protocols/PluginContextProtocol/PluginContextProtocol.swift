//
//  PluginContextProtocol.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 13.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import Foundation
import PackagePlugin

protocol PluginContextProtocol {
	
	// MARK: - Properties
	
	var pluginWorkDirectory: Path { get }
	var rootDirectory: Path { get }
	
	// MARK: - Methods
	
	func tool(named name: String) throws -> PluginContext.Tool
}

// MARK: - Default implementation

extension PluginContextProtocol {
	
	// MARK: - Internal properties
	
	var executablePath: Path {
		get throws {
			try tool(named: .tool.name).path
		}
	}
	
	var swiftPackageManagerInputPath: Path {
		get throws {
			var currentDirectory = pluginWorkDirectory
			
			while true {
				let parentDirectory = currentDirectory.removingLastComponent()
				
				guard currentDirectory != parentDirectory else { throw CocoaError(.fileReadInvalidFileName) }
				if parentDirectory.stem == .directories.derivedDataDirectory { break }
				
				currentDirectory = parentDirectory
			}
			
			return currentDirectory.appending([
				.directories.sourcePackageDirectory,
				.directories.checkoutsDirectory
			])
		}
	}
	
	var cocoaPodsInputPath: Path {
		rootDirectory.appending(subpath: .directories.podsDirectory)
	}
	
	var outputPath: Path {
		pluginWorkDirectory
			.appending([
				.directories.acknowledgementsGeneratorDirectory,
				.directories.acknowledgementFile
			])
	}
}

// MARK: - PluginContext+PluginContextProtocol

extension PluginContext: PluginContextProtocol {
	
	// MARK: - Internal properties
	
	var rootDirectory: Path {
		`package`.directory
	}
}

#if canImport(XcodeProjectPlugin)

// MARK: - XcodePluginContext+PluginContextProtocol

import XcodeProjectPlugin

extension XcodePluginContext: PluginContextProtocol {
	
	// MARK: - Internal properties
	
	var rootDirectory: Path {
		xcodeProject.directory
	}
}

#endif

// MARK: - Constants

private extension String.directories {
	static let derivedDataDirectory = "DerivedData"
	static let sourcePackageDirectory = "SourcePackages"
	static let checkoutsDirectory = "checkouts"
	static let podsDirectory = "Pods"
	static let acknowledgementsGeneratorDirectory = "AcknowledgementsGenerator"
	
	static let acknowledgementFile = "Acknowledgement.swift"
}
