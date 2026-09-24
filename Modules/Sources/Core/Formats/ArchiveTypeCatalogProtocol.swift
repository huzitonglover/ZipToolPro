//
//  ArchiveTypeCatalogProtocol.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//


public protocol ArchiveTypeCatalogProtocol: AnyObject, Sendable {
    /// All known format IDs (JSON `formats[].id`)
    func allFormatIds() -> [String]

    /// Engine options defined in the JSON for this format.
    func engineOptions(for formatId: String) -> [EngineDto]

    /// Default engine for this format as defined in the JSON.
    func defaultEngine(for formatId: String) -> ArchiveEngineType?
}
