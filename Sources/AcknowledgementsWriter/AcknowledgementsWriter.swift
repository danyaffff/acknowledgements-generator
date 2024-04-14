//
//  AcknowledgementsWriter.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 13.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import Foundation

public enum AcknowledgementsWriter {
	
	// MARK: - Public static methods
	
	public static func write(code: String, outputURL: URL) throws {
		try code.write(
			to: outputURL,
			atomically: true,
			encoding: .utf8
		)
	}
}
