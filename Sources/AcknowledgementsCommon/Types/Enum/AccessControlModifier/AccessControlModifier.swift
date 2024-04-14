//
//  AccessControlModifier.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 13.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

public enum AccessControlModifier: String {
	case `public`
	case `internal`
}

// MARK: - CustomStringConvertible

extension AccessControlModifier: CustomStringConvertible {
	
	// MARK: - Public properties
	
	public var description: String {
		rawValue.capitalized
	}
}
