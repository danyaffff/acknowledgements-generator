//
//  GenerateCommand.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 09.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import Foundation
import ArgumentParser
import AcknowledgementsCommon
import AcknowledgementsReader
import AcknowledgementsGenerator
import AcknowledgementsWriter

struct GenerateCommand: ParsableCommand {
	
	// MARK: - Internal properties
	
	@Option(
		name: .customLong("input"),
		help: "Path to Packages directory.",
		completion: .directory,
		transform: { .init(filePath: $0, directoryHint: .isDirectory) }
	)
	var inputURLs: [URL]
	
	@Option(
		name: .customLong("output"),
		help: "Path to write generated Swift output.",
		completion: .file(extensions: ["swift"]),
		transform: { .init(filePath: $0, directoryHint: .notDirectory) }
	)
	var outputURL: URL
	
	@Option(
		name: .customLong("access"),
		help: "Access control modifier of generated Swift code.",
		transform: { .init(rawValue: $0) }
	)
	var accessControlModifier: AccessControlModifier?
	
	// MARK: - Internal methods
	
	func run() throws {
		let acknowledgements = try AcknowledgementsReader.read(inputURLs: inputURLs)
		let generatedCode = try AcknowledgementsGenerator.generate(
			accessControlModifier: accessControlModifier ?? .internal,
			acknowledgements: acknowledgements
		)
		try AcknowledgementsWriter.write(code: generatedCode, outputURL: outputURL)
	}
}
