//
//  Constants.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 12.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

private protocol Constants {
	associatedtype ParentType
}

// MARK: - String

extension String {
	enum constants: Constants {
		typealias ParentType = String
	}
}
