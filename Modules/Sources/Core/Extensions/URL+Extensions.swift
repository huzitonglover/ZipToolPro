//
//  Url+Extensions.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import Foundation

extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    
    var fileSize: Int? {
        let attrs = try? FileManager.default.attributesOfItem(atPath: path)
        return (attrs?[.size] as? NSNumber)?.intValue
    }

    var permissions: Int? {
        let attrs = try? FileManager.default.attributesOfItem(atPath: path)
        return (attrs?[.posixPermissions] as? NSNumber)?.intValue
    }
    
    var modificationDate: Date? {
        let attrs = try? FileManager.default.attributesOfItem(atPath: path)
        return (attrs?[.modificationDate] as? Date)
    }
}
