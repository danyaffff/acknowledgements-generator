//
//  AcknowledgementsReader.swift
//  AcknowledgementsGenerator
//
//  Created by Daniil on 10.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import Foundation
import AcknowledgementsCommon

public enum AcknowledgementsReader {
	
	// MARK: - Public static methods
	
	public static func read(inputURLs: [URL]) throws -> [Acknowledgement] {
		try collectAcknowledgements(
			packageURLs: getPackageURLs(
				inputURLs: inputURLs
			)
		)
		.sorted { $0.name < $1.name }
	}
	
	// MARK: - Private static methods
	
	private static func getPackageURLs(inputURLs: [URL]) throws -> [URL] {
		inputURLs
			.compactMap { inputURL in
				try? FileManager.default
					.contentsOfDirectory(
						at: inputURL,
						includingPropertiesForKeys: nil,
						options: [.skipsHiddenFiles]
					)
					.filter(\.hasDirectoryPath)
			}
			.flatMap { $0 }
	}
	
	private static func collectAcknowledgements(packageURLs: [URL]) -> [Acknowledgement] {
		packageURLs
			.compactMap { packageURL in
				guard
					let licenseURL = try? FileManager.default
						.contentsOfDirectory(
							at: packageURL,
							includingPropertiesForKeys: nil,
							options: .skipsHiddenFiles
						)
						.first(
							where: { contentURL in
								contentURL
									.deletingPathExtension()
									.lastPathComponent
									.uppercased() == .constants.uppercasedLicense
							}
						),
					let license = try? String(contentsOf: licenseURL)
				else { return nil }
				return .init(
					name: packageURL.lastPathComponent,
					license: license
				)
			}
	}
}

// MARK: - Constants

private extension String.constants {
	static let uppercasedLicense = "LICENSE"
}
