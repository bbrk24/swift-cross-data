import Foundation

public struct DatabaseLocation: Sendable, Equatable {
    enum Value: Sendable, Equatable {
        case inMemory
        case fileUrl(URL)
    }

    var value: Value

    /// Use a transient, in-memory database that will be wiped upon process termination.
    public static let inMemory = DatabaseLocation(value: .inMemory)

    /// Use a database located at the given file path.
    public static func filePath(_ path: String) -> DatabaseLocation {
        .init(value: .fileUrl(URL(fileURLWithPath: path)))
    }

    /// Use a database located at the given file URL.
    public static func url(_ url: URL) -> DatabaseLocation {
        precondition(
            url.scheme == "file",
            "URL must be a file URL (actual scheme: '\(url.scheme ?? "")')"
        )
        return .init(value: .fileUrl(url))
    }

    public enum DataType: Sendable, Hashable, BitwiseCopyable {
        /// Generic user data.
        ///
        /// This is the most common place where user-specific save data is written.
        case data
        /// Config values.
        ///
        /// On Linux, this is `~/.config` unless overridden by `$XDG_CONFIG_HOME`. On most platforms
        /// this is the same as ``data``.
        case config
        /// State data.
        ///
        /// This is for data that should be persisted, but isn't portable or can be erased. For
        /// example, this could store some sort of user action history or logs.
        case state
        /// Cache data.
        ///
        /// This is a non-temporary directory that may nonetheless be cleaned up when the app isn't
        /// running. Do not store any important user data here; data missing from this location
        /// should not be considered an error.
        case cache
    }

    /// Use a recommended folder for the current platform, creating it if it doesn't exist.
    /// - Parameters:
    ///   - appIdentifier: A unique identifier for the current application, such as the main bundle
    ///     ID.
    ///   - fileName: The file name to use within the suggested folder.
    ///   - dataType: The type of data being stored. Note that this is not respected on all
    ///     platforms, so you should not create multiple database files with the same `fileName` and
    ///     different `dataType`.
    /// - Throws: If the directory could not be created.
    public static func suggestedLocation(
        appIdentifier: String,
        fileName: String,
        dataType: DataType = .data
    ) throws -> DatabaseLocation {
        #if os(Linux)
            let directoryUrl =
                switch dataType {
                case .data:
                    (ProcessInfo.processInfo.environment["XDG_DATA_HOME"]
                        .flatMap {
                            $0.hasPrefix("/") ? URL(filePath: $0) : nil
                        }
                        ?? URL.homeDirectory.appending(
                            components: ".local",
                            "share",
                            directoryHint: .isDirectory
                        ))
                        .appending(component: appIdentifier, directoryHint: .isDirectory)
                case .config:
                    (ProcessInfo.processInfo.environment["XDG_CONFIG_HOME"]
                        .flatMap {
                            $0.hasPrefix("/") ? URL(filePath: $0) : nil
                        }
                        ?? URL.homeDirectory.appending(
                            component: ".config",
                            directoryHint: .isDirectory
                        ))
                        .appending(component: appIdentifier, directoryHint: .isDirectory)
                case .state:
                    (ProcessInfo.processInfo.environment["XDG_STATE_HOME"]
                        .flatMap {
                            $0.hasPrefix("/") ? URL(filePath: $0) : nil
                        }
                        ?? URL.homeDirectory.appending(
                            components: ".local",
                            "state",
                            directoryHint: .isDirectory
                        ))
                        .appending(component: appIdentifier, directoryHint: .isDirectory)
                case .cache:
                    (ProcessInfo.processInfo.environment["XDG_CACHE_HOME"]
                        .flatMap {
                            $0.hasPrefix("/") ? URL(filePath: $0) : nil
                        }
                        ?? URL.homeDirectory.appending(
                            components: ".cache",
                            directoryHint: .isDirectory
                        ))
                        .appending(component: appIdentifier, directoryHint: .isDirectory)
                }

            if !FileManager.default.fileExists(atPath: directoryUrl.path) {
                try FileManager.default.createDirectory(
                    at: directoryUrl,
                    withIntermediateDirectories: true,
                    attributes: [.posixPermissions: NSNumber(value: 0o700 as Int16)]
                )
            }
        #elseif os(Windows)
            var directoryUrl =
                switch dataType {
                case .data, .config:
                    URL(
                        filePath: ProcessInfo.processInfo.environment["APPDATA"]!,
                        directoryHint: .isDirectory
                    )
                    .appending(component: appIdentifier, directoryHint: .isDirectory)
                case .state, .cache:
                    // Windows doesn't have a dedicated cache directory, so map .cache to the same
                    // location as .state
                    URL(
                        filePath: ProcessInfo.processInfo.environment["LOCALAPPDATA"]!,
                        directoryHint: .isDirectory
                    )
                    .appending(component: appIdentifier, directoryHint: .isDirectory)
                }

            if !FileManager.default.fileExists(atPath: directoryUrl.path) {
                try FileManager.default.createDirectory(
                    at: directoryUrl,
                    withIntermediateDirectories: false
                )
            }
        #elseif os(macOS)
            let directoryUrl =
                switch dataType {
                case .cache:
                    FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                        .appending(component: appIdentifier, directoryHint: .isDirectory)
                default:
                    FileManager.default
                        .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
                        .appending(component: appIdentifier, directoryHint: .isDirectory)
                }

            if !FileManager.default.fileExists(atPath: directoryUrl.path) {
                try FileManager.default.createDirectory(
                    at: directoryUrl,
                    withIntermediateDirectories: false,
                    attributes: [.posixPermissions: NSNumber(value: 0o755 as Int16)]
                )
            }
        #elseif os(iOS) || os(tvOS)
            // Within the sandbox, you're only given access to .cachesDirectory, .documentDirectory,
            // and temporary directories.
            let directoryUrl =
                FileManager.default
                .urls(
                    for: dataType == .cache ? .cachesDirectory : .documentDirectory,
                    in: .userDomainMask
                )[0]
        #else
            #error("Unsupported operating system")
        #endif

        return .url(
            directoryUrl.appending(component: fileName, directoryHint: .notDirectory)
        )
    }
}
