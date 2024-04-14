//
//  Acknowledgement.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 13.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import Foundation

public struct Acknowledgement {
	
	// MARK: - Public properties
	
	public let name: String
	public let license: String
	
	public let validPropertyName: String
	
	// MARK: - Initialization
	
	public init?(
		name: String,
		license: String
	) {
		self.name = name
		self.license = license
		
		self.validPropertyName = name
			.drop { !$0.isLetter }
			.components(separatedBy: .alphanumerics.inverted)
			.enumerated()
			.map { $0 == .zero ? $1.uncapitlized : $1.capitalized }
			.joined()
		
		guard !validPropertyName.isEmpty else { return nil }
	}
}
