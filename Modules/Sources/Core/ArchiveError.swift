//
//  ArchiveError.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//


enum ArchiveError: Error {
    // used to say that the archive is invalid and cannot be extracted
    case invalidArchive(_ message: String)
    case loadFailed(_ message: String)
    case extractionFailed(_ message: String)
    case passwordCancelled
    case xadError(_ code: Int32, _ message: String)
}
