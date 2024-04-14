//
//  Constants.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 09.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

private protocol Constants {
	associatedtype ParentType
}

// MARK: - String

extension String {
	enum tool: Constants {
		typealias ParentType = String
	}
	
	enum file: Constants {
		typealias ParentType = String
	}
	
	enum plugin: Constants {
		typealias ParentType = String
	}
	
	enum directories: Constants {
		typealias ParentType = String
	}
}
