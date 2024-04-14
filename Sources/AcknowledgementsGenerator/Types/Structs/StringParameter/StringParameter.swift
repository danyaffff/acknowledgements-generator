//
//  StringParameter.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 14.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import SwiftSyntax

struct StringParameter<Root>: ParameterProtocol {
	
	// MARK: - Internal properties
	
	let name: String
	let valueAccessor: (Root) -> String
	
	// MARK: - Internal methods
	
	func expression(root: Root) -> StringLiteralExprSyntax {
		.init(content: valueAccessor(root))
	}
}
