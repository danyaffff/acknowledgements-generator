//
//  String+Uncapitalized.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 13.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

extension String {
	
	// MARK: - Internal properties
	
	var uncapitlized: String {
		prefix(1).lowercased() + dropFirst()
	}
}
