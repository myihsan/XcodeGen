import Foundation
import PathKit
import XcodeProj

extension PBXProductType {

    init?(string: String) {
        if let type = PBXProductType(rawValue: string) {
            self = type
        } else if let type = PBXProductType(rawValue: "com.apple.product-type.\(string)") {
            self = type
        } else {
            return nil
        }
    }

    public var isFramework: Bool {
        self == .framework || self == .staticFramework
    }

    public var isLibrary: Bool {
        self == .staticLibrary || self == .dynamicLibrary
    }

    public var isExtension: Bool {
        fileExtension == "appex"
    }

    public var isApp: Bool {
        fileExtension == "app"
    }

    public var isTest: Bool {
        fileExtension == "xctest"
    }

    public var isExecutable: Bool {
        isApp || isExtension || isTest || self == .commandLineTool
    }

    public var name: String {
        rawValue.replacingOccurrences(of: "com.apple.product-type.", with: "")
    }
}

extension Platform {

    public var emoji: String {
        switch self {
        case .iOS: return "📱"
        case .watchOS: return "⌚️"
        case .tvOS: return "📺"
        case .macOS: return "🖥"
        }
    }
}

extension XCScheme.CommandLineArguments {
    // Dictionary is a mapping from argument name and if it is enabled by default
    public convenience init(_ dict: [String: Bool]) {
        let args = dict.map { tuple in
            XCScheme.CommandLineArguments.CommandLineArgument(name: tuple.key, enabled: tuple.value)
        }.sorted { $0.name < $1.name }
        self.init(arguments: args)
    }
}

extension BreakpointExtensionID {

    init(string: String) throws {
        if let id = BreakpointExtensionID(rawValue: "Xcode.Breakpoint.\(string)Breakpoint") {
            self = id
        } else if let id = BreakpointExtensionID(rawValue: string) {
            self = id
        } else {
            throw SpecParsingError.unknownBreakpointType(string)
        }
    }
}

extension BreakpointActionExtensionID {

    init(string: String) throws {
        if let type = BreakpointActionExtensionID(rawValue: "Xcode.BreakpointAction.\(string)") {
            self = type
        } else if let type = BreakpointActionExtensionID(rawValue: string) {
            self = type
        } else {
            throw SpecParsingError.unknownBreakpointActionType(string)
        }
    }
}

