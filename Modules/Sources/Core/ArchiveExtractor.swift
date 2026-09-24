//
//  ArchiveExtractor.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import Foundation

struct SingleExtractionResult {
    let url: URL
    let tempDir: URL
}

struct MultiExtractionResult {
    let urls: [UUID: URL]
    let tempDirs: [URL]
}

final actor ArchiveExtractor {
    private let archiveEngineSelector: ArchiveEngineSelectorProtocol
    private let passwordResolver: ArchivePasswordResolver

    init(
        archiveEngineSelector: ArchiveEngineSelectorProtocol,
        passwordResolver: @escaping ArchivePasswordResolver
    ) {
        self.archiveEngineSelector = archiveEngineSelector
        self.passwordResolver = passwordResolver
    }

    /// Moves the given set of extracted temporary files to another destination.
    ///
    /// This is usually used to move extracted file(s) from their temporary location
    /// to the final target directory.
    ///
    /// - Parameters:
    ///   - extractedURLs: The extracted item urls keyed by item id.
    ///   - destination: The target directory.
    ///   - items: List of items relevant for being moved.
    private func moveExtractedItems(
        _ extractedURLs: [UUID: URL],
        to destination: URL,
        items: [ArchiveItem]
    ) throws {
        _ = destination.startAccessingSecurityScopedResource()
        defer { destination.stopAccessingSecurityScopedResource() }
        
        let itemsById = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
        let extractionRoots = uniquedExtractionRoots(
            for: items,
            in: destination,
            itemsById: itemsById
        )

        // Finally, move the file from the temp location to the actual destination.
        for (id, sourceURL) in extractedURLs.sorted(by: { lhs, rhs in
            hierarchyDepth(of: lhs.key, itemsById: itemsById) < hierarchyDepth(of: rhs.key, itemsById: itemsById)
        }) {
            guard let item = itemsById[id] else { continue }

            let targetURL = destination.appendingPathComponent(
                relativeExtractionPath(
                    for: item,
                    extractionRoots: extractionRoots,
                    itemsById: itemsById
                ),
                isDirectory: item.type == .directory
            )
            let parentURL = targetURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(
                at: parentURL,
                withIntermediateDirectories: true
            )
            guard FileManager.default.fileExists(atPath: sourceURL.path) else {
                continue
            }
            try FileManager.default.moveItem(at: sourceURL, to: targetURL)
        }
    }

    private struct ExtractionRoot {
        let item: ArchiveItem
        let archivePathPrefix: String?
        let outputName: String
        let preservesContainer: Bool
    }

    private func relativeExtractionPath(
        for item: ArchiveItem,
        extractionRoots: [ExtractionRoot],
        itemsById: [UUID: ArchiveItem]
    ) -> String {
        guard let root = extractionRoots.first(where: { isItem(item, containedIn: $0.item, itemsById: itemsById) }) else {
            return item.name
        }

        guard root.preservesContainer else {
            return root.outputName
        }

        guard
            let itemPath = item.virtualPath.map(normalizedRelativePath),
            let archivePathPrefix = root.archivePathPrefix,
            itemPath != archivePathPrefix
        else {
            return root.outputName
        }

        let prefix = archivePathPrefix + "/"
        guard itemPath.hasPrefix(prefix) else {
            return root.outputName + "/" + item.name
        }

        return root.outputName + "/" + String(itemPath.dropFirst(prefix.count))
    }

    private func extractionRoots(
        for items: [ArchiveItem],
        itemsById: [UUID: ArchiveItem]
    ) -> [ExtractionRoot] {
        let itemIDs = Set(items.map(\.id))
        return items
            .filter { item in
                guard let parent = item.parent else { return true }
                return !itemIDs.contains(parent)
            }
            .map { item in
                let preservesContainer = item.type == .directory || item.type == .virtual
                return ExtractionRoot(
                    item: item,
                    archivePathPrefix: item.virtualPath.map(normalizedRelativePath)
                        ?? inferredArchivePathPrefix(for: item, itemsById: itemsById),
                    outputName: item.name,
                    preservesContainer: preservesContainer
                )
            }
    }

    private func uniquedExtractionRoots(
        for items: [ArchiveItem],
        in destination: URL,
        itemsById: [UUID: ArchiveItem]
    ) -> [ExtractionRoot] {
        var reservedNames: Set<String> = []

        return extractionRoots(for: items, itemsById: itemsById).map { root in
            ExtractionRoot(
                item: root.item,
                archivePathPrefix: root.archivePathPrefix,
                outputName: uniqueOutputName(
                    root.outputName,
                    preservesExtension: !root.preservesContainer,
                    in: destination,
                    reservedNames: &reservedNames
                ),
                preservesContainer: root.preservesContainer
            )
        }
    }

    private func uniqueOutputName(
        _ name: String,
        preservesExtension: Bool,
        in destination: URL,
        reservedNames: inout Set<String>
    ) -> String {
        let baseName: String
        let pathExtension: String

        if preservesExtension {
            let url = URL(fileURLWithPath: name)
            pathExtension = url.pathExtension
            baseName = pathExtension.isEmpty
                ? name
                : String(name.dropLast(pathExtension.count + 1))
        } else {
            baseName = name
            pathExtension = ""
        }

        var counter = 0
        while true {
            let candidate = counter == 0
                ? name
                : pathExtension.isEmpty
                    ? "\(baseName)\(counter)"
                    : "\(baseName)\(counter).\(pathExtension)"
            let reservedKey = candidate.lowercased()
            let candidateURL = destination.appendingPathComponent(candidate)

            if
                !reservedNames.contains(reservedKey),
                !FileManager.default.fileExists(atPath: candidateURL.path)
            {
                reservedNames.insert(reservedKey)
                return candidate
            }

            counter += 1
        }
    }

    private func inferredArchivePathPrefix(
        for root: ArchiveItem,
        itemsById: [UUID: ArchiveItem]
    ) -> String? {
        let descendantPrefixes = itemsById.values.compactMap { item -> [String]? in
            guard
                item.id != root.id,
                isItem(item, containedIn: root, itemsById: itemsById),
                let virtualPath = item.virtualPath
            else {
                return nil
            }

            var components = normalizedRelativePath(virtualPath).split(separator: "/").map(String.init)
            if item.type != .directory {
                components = Array(components.dropLast())
            }
            return components.isEmpty ? nil : components
        }

        guard var commonPrefix = descendantPrefixes.first else {
            return nil
        }

        for components in descendantPrefixes.dropFirst() {
            commonPrefix = Array(zip(commonPrefix, components).prefix { $0 == $1 }.map(\.0))
        }

        guard
            let matchingIndex = commonPrefix.lastIndex(of: root.name)
        else {
            return root.name
        }

        return commonPrefix[...matchingIndex].joined(separator: "/")
    }

    private func isItem(
        _ item: ArchiveItem,
        containedIn root: ArchiveItem,
        itemsById: [UUID: ArchiveItem]
    ) -> Bool {
        if item.id == root.id {
            return true
        }

        var parent = item.parent.flatMap { itemsById[$0] }
        while let current = parent {
            if current.id == root.id {
                return true
            }
            parent = current.parent.flatMap { itemsById[$0] }
        }

        return false
    }

    private func hierarchyDepth(
        of itemID: UUID,
        itemsById: [UUID: ArchiveItem]
    ) -> Int {
        var depth = 0
        var parent = itemsById[itemID]?.parent.flatMap { itemsById[$0] }
        while let current = parent {
            depth += 1
            parent = current.parent.flatMap { itemsById[$0] }
        }
        return depth
    }

    private func normalizedRelativePath(_ path: String) -> String {
        path
            .split(separator: "/", omittingEmptySubsequences: true)
            .joined(separator: "/")
    }

    /// Extracts a single batch into a newly created temp directory.
    ///
    /// - Parameter batch: The batch to extract.
    /// - Returns: The extracted urls keyed by item id and the temp directory used for extraction.
    private func extract(
        batch: ResolvedBatch
    ) async throws -> ([UUID: URL], URL) {
        let utilities = ArchiveSupportUtilities()

        guard let temp = utilities.createTempDirectory() else {
            throw ArchiveError.extractionFailed("Could not create temp directory")
        }

        let engine = archiveEngineSelector.engine(for: batch.engineType)

        let extractedURLs = try await engine.extract(
            items: batch.items,
            from: batch.archiveURL,
            to: temp.url,
            passwordResolver: passwordResolver
        )

        return (extractedURLs.urlsByItemID, temp.url)
    }

    /// Extracts a single item from a resolved batch to the target directory through a temp directory.
    ///
    /// The item is extracted to a temp directory first, then moved to the target.
    /// This avoids sandboxing issues when extracting directly to a user-chosen destination.
    ///
    /// - Parameters:
    ///   - batch: A resolved batch containing the item, its archive URL, and engine type.
    ///   - destination: Destination folder. If `nil`, the extracted file stays in temp.
    /// - Returns: The extracted file URL and the temp directory used.
    public func extract(
        batch: ResolvedBatch,
        to destination: URL? = nil
    ) async throws -> SingleExtractionResult {
        guard let item = batch.items.first else {
            throw ArchiveError.extractionFailed("Cannot extract: no items provided")
        }
        let (extractedURLs, tempDirectory) = try await extract(batch: batch)

        // For single-item extraction, we expect exactly one extracted result.
        guard let extractedURL = extractedURLs[item.id] ?? extractedURLs.values.first else {
            throw ArchiveError.extractionFailed("Extraction of item failed, but no url was returned")
        }

        // Only if there is a target directory then we move the file there,
        // otherwise we keep it in the temp spot.
        if let destination {
            try moveExtractedItems(extractedURLs, to: destination, items: [item])
        }

        return SingleExtractionResult(
            url: extractedURL,
            tempDir: tempDirectory
        )
    }

    /// Extracts items from multiple resolved batches to the target directory through temp directories.
    ///
    /// Each batch is extracted to its own temp directory, then moved to the target.
    /// This avoids sandboxing issues when extracting directly to a user-chosen destination.
    ///
    /// - Parameters:
    ///   - batches: Resolved batches, each containing items grouped by archive URL and engine type.
    ///   - destination: Destination folder. If `nil`, extracted files stay in temp.
    /// - Returns: All extracted file URLs keyed by item ID, and the temp directories used.
    public func extract(
        batches: [ResolvedBatch],
        to destination: URL? = nil
    ) async throws -> MultiExtractionResult {
        var allExtractedURLs: [UUID: URL] = [:]
        var tempDirectories: [URL] = []

        for batch in batches {
            let (extractedURLs, tempDirectory) = try await extract(batch: batch)

            tempDirectories.append(tempDirectory)
            allExtractedURLs.merge(extractedURLs) { current, _ in current }

            // Only if there is a target directory then we move the files there,
            // otherwise we keep them in the temp spot.
            if let destination {
                try moveExtractedItems(extractedURLs, to: destination, items: batch.items)
            }
        }

        return MultiExtractionResult(
            urls: allExtractedURLs,
            tempDirs: tempDirectories
        )
    }
    
    /// Extracts the given archive fully
    /// - Parameters:
    ///   - url: archive to extract
    ///   - archiveEngineType: type of engine
    ///   - destination: destination directory
    public func extractAll(
        _ url: URL,
        archiveTypeId: String,
        to destination: URL
    ) async throws {
        _ = destination.startAccessingSecurityScopedResource()
        defer { destination.stopAccessingSecurityScopedResource() }
        
        guard let engine = archiveEngineSelector.engine(for: archiveTypeId) else {
            throw ArchiveError.extractionFailed("Could not determine archive engine for \(archiveTypeId).")
        }

        try await engine.extract(url, to: destination, passwordResolver: passwordResolver)
    }
}
