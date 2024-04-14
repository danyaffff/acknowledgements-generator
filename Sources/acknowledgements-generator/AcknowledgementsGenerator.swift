//
//  AcknowledgementsGenerator.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 09.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import ArgumentParser

@main
struct AcknowledgementsGeneratorCommand: ParsableCommand {
	
	// MARK: - Internal static properties
	
	static let configuration = CommandConfiguration(
		commandName: "acknowledgements-generator",
		abstract: "Generates Swift code from LICENSE files.",
		version: "1.0.0",
		subcommands: [GenerateCommand.self],
		defaultSubcommand: GenerateCommand.self
	)
}
