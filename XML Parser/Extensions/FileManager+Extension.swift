//
//  FileManager+Extension.swift
//  XML Parser
//
//  Created by Denis Bystruev on 09/09/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

extension FileManager {
    func isReadableNotDirectory(atPath path: String) -> Bool {
        var isDirectory = ObjCBool(false)
        guard isReadableFile(atPath: path) else { return false }
        guard fileExists(atPath: path, isDirectory: &isDirectory) else { return false }        
        return !isDirectory.boolValue
    }
}
