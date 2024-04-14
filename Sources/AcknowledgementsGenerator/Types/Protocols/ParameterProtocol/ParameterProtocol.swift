//
//  ParameterProtocol.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 14.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import SwiftSyntax

protocol ParameterProtocol<Root> {
	
	// MARK: - Associated types
	
	associatedtype Root
	associatedtype Value
	associatedtype ExprSyntax: ExprSyntaxProtocol
	
	// MARK: - Properties
	
	var name: String { get }
	var valueAccessor: (Root) -> Value { get }
	
	// MARK: - Methods
	
	func expression(root: Root) -> ExprSyntax
}
