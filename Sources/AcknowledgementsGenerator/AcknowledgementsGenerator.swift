//
//  AcknowledgementsGenerator.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 09.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import AcknowledgementsCommon

public enum AcknowledgementsGenerator {
	
	// MARK: - Private static properties
	
	private static let parameters: [any ParameterProtocol<Acknowledgement>] = [
		StringParameter(name: .constants.name, valueAccessor: \.name),
		StringParameter(name: .constants.license, valueAccessor: \.license)
	]
	
	// MARK: - Public static methods
	
	public static func generate(
		accessControlModifier: AccessControlModifier,
		acknowledgements: [Acknowledgement]
	) throws -> String {
		SourceFileSyntax {
			`struct`(accessControlModifier: accessControlModifier)
			caseIterableExtension(
				accessControlModifier: accessControlModifier,
				acknowledgements: acknowledgements
			)
			convenienceExtension(
				accessControlModifier: accessControlModifier,
				acknowledgements: acknowledgements
			)
		}
		.formatted(using: .init(indentationWidth: .tab))
		.description
	}
	
	// MARK: - Private static methods
	
	private static func `struct`(
		accessControlModifier: AccessControlModifier
	) -> StructDeclSyntax {
		StructDeclSyntax(
			name: .identifier(.constants.acknowledgement),
			inheritanceClause: InheritanceClauseSyntax {
				inheritance(typeName: .constants.sendable)
				inheritance(typeName: .constants.hashable)
			},
			memberBlockBuilder: {
				for parameterIndex in parameters.indices {
					let parameter = parameters[parameterIndex]
					
					`let`(
						leadingTrivia: mark(
							text: .constants.properties(
								accessControlModifier: accessControlModifier
							),
							shown: parameterIndex == .zero
						),
						name: parameter.name,
						type: IdentifierTypeSyntax(
							name: .identifier(.constants.string)
						)
					)
				}
			}
		)
	}
	
	private static func caseIterableExtension(
		accessControlModifier: AccessControlModifier,
		acknowledgements: [Acknowledgement]
	) -> ExtensionDeclSyntax {
		ExtensionDeclSyntax(
			leadingTrivia: mark(
				text: .constants.caseIterable
			),
			extendedType: IdentifierTypeSyntax(
				name: .identifier(.constants.acknowledgement)
			),
			inheritanceClause: InheritanceClauseSyntax {
				inheritance(typeName: .constants.caseIterable)
			},
			memberBlockBuilder: {
				`let`(
					leadingTrivia: mark(
						text: .constants.staticProperties(
							accessControlModifier: accessControlModifier
						)
					),
					isStatic: true,
					name: .constants.allCases,
					type: ArrayTypeSyntax(
						element: IdentifierTypeSyntax(
							name: .keyword(.Self)
						)
					),
					initializer: InitializerClauseSyntax(
						value: ArrayExprSyntax(
							rightSquare: .rightSquareToken(leadingTrivia: .newline),
							elementsBuilder: {
								for acknowledgement in acknowledgements {
									ArrayElementSyntax(
										leadingTrivia: .newline,
										expression: TypeExprSyntax(
											type: MemberTypeSyntax(
												baseType: IdentifierTypeSyntax(
													name: .identifier(String())  // .keyword(.Self, presence: .missing) cause leadingTrivia ignoring
												),
												name: .identifier(acknowledgement.validPropertyName)
											)
										)
									)
								}
							}
						)
					)
				)
			}
		)
	}
	
	private static func convenienceExtension(
		accessControlModifier: AccessControlModifier,
		acknowledgements: [Acknowledgement]
	) -> ExtensionDeclSyntax {
		ExtensionDeclSyntax(
			leadingTrivia: mark(
				text: .constants.convenience
			),
			extendedType: IdentifierTypeSyntax(
				name: .identifier(.constants.acknowledgement)
			),
			memberBlockBuilder: {
				for acknowledgementIndex in acknowledgements.indices {
					let acknowledgement = acknowledgements[acknowledgementIndex]
					
					`let`(
						leadingTrivia: mark(
							text: .constants.staticProperties(
								accessControlModifier: accessControlModifier
							),
							shown: acknowledgementIndex == acknowledgements.startIndex
						),
						isStatic: true,
						name: acknowledgement.validPropertyName,
						type: IdentifierTypeSyntax(
							name: .keyword(.Self)
						),
						initializer: InitializerClauseSyntax(
							value: FunctionCallExprSyntax(
								calledExpression: MemberAccessExprSyntax(
									base: DeclReferenceExprSyntax(
										baseName: .keyword(.Self, presence: .missing)
									),
									name: .identifier(.constants.`init`)
								),
								leftParen: .leftParenToken(),
								rightParen: .rightParenToken(leadingTrivia: .newline),
								argumentsBuilder: {
									for parameterIndex in parameters.indices {
										let parameter = parameters[parameterIndex]
										
										LabeledExprSyntax(
											label: parameter.name,
											expression: parameter.expression(root: acknowledgement)
										)
										.with(
											\.trailingComma,
											 parameterIndex != parameters.count - 1 ? .commaToken() : nil
										)
										.with(\.leadingTrivia, .newline)
									}
								}
							)
						),
						trailingTrivia: acknowledgementIndex == acknowledgements.count - 1 ? nil : .newlines(2)
					)
				}
			}
		)
	}
	
	private static func `let`(
		leadingTrivia: Trivia? = nil,
		isStatic: Bool = false,
		name: String,
		type: some TypeSyntaxProtocol,
		initializer: InitializerClauseSyntax? = nil,
		trailingTrivia: Trivia? = nil
	) -> VariableDeclSyntax {
		VariableDeclSyntax(
			leadingTrivia: leadingTrivia,
			modifiers: .init {
				if isStatic {
					DeclModifierSyntax(name: .keyword(.static))
				}
			},
			bindingSpecifier: .keyword(.let),
			bindingsBuilder: {
				PatternBindingSyntax(
					pattern: IdentifierPatternSyntax(
						identifier: .identifier(name)
					),
					typeAnnotation: TypeAnnotationSyntax(
						type: type
					),
					initializer: initializer
				)
			},
			trailingTrivia: trailingTrivia
		)
	}
	
	private static func inheritance(typeName: String) -> InheritedTypeSyntax {
		InheritedTypeSyntax(
			type: IdentifierTypeSyntax(
				name: .identifier(typeName)
			)
		)
	}
	
	private static func mark(text: String, shown: Bool = true) -> Trivia? {
		guard shown else { return nil }
		return [
			.newlines(2),
			.lineComment(.constants.mark(text: text)),
			.newlines(2)
		]
	}
}

// MARK: - Constants

private extension String.constants {
	static let acknowledgement = "Acknowledgement"
	
	static let name = "name"
	static let license = "license"
	static let allCases = "allCases"
	
	static let `init` = "init"
	
	static let string = "String"
	static let sendable = "Sendable"
	static let hashable = "Hashable"
	static let caseIterable = "CaseIterable"
	
	static let convenience = "Convenience"
	
	static func mark(text: String) -> String {
		"// MARK: - \(text)"
	}
	
	static func properties(accessControlModifier: AccessControlModifier) -> String {
		"\(accessControlModifier) properties"
	}
	
	static func staticProperties(accessControlModifier: AccessControlModifier) -> String {
		"\(accessControlModifier) static properties"
	}
}
