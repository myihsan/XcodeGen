//
//  CarthageVersionLoader.swift
//  XcodeGenKit
//
//  Created by Yonas Kolb on 24/3/19.
//

import Foundation
import PathKit
import ProjectSpec

class CarthageVersionLoader {

    private let buildPath: Path
    private var cachedFiles: [String: CarthageVersionFile] = [:]

    init(buildPath: Path) {
        self.buildPath = buildPath
    }

    func getVersionFile(for dependency: String) throws -> CarthageVersionFile {
        if let versionFile = cachedFiles[dependency] {
            return versionFile
        }
        let filePath = buildPath + ".\(dependency).version"
        let data = try filePath.read()
        let carthageVersionFile = try JSONDecoder().decode(CarthageVersionFile.self, from: data)
        cachedFiles[dependency] = carthageVersionFile
        return carthageVersionFile
    }
}

struct CarthageVersionFile: Decodable {

    private struct Reference: Decodable, Equatable {
        public let name: String
        public let hash: String
    }

    private let data: [Platform: [String]]

    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Platform.self)
        data = try Platform.allCases.reduce(into: [:]) { data, platform in
            let references = try container.decodeIfPresent([Reference].self, forKey: platform) ?? []
            let frameworks = Set(references.map { $0.name }).sorted()
            data[platform] = frameworks
        }
    }
}

extension Platform: CodingKey {

    public var stringValue: String {
        return carthageName
    }
}

extension CarthageVersionFile {
    func frameworks(for platform: Platform) -> [String] {
        return data[platform] ?? []
    }
}
