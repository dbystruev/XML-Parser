//
//  BundleManager.swift
//  XML Parser
//
//  Created by Denis Bystruev on 09/09/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

class BundleManager {
    func getFileNames(with fileExtension: String) -> [String] {
        let fileManager = FileManager.default
        guard let url = Bundle.main.resourceURL else { return [] }
        guard let items = try? fileManager.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        ) else { return [] }
        
        let suffix = ".\(fileExtension)"
        
        return items.compactMap { url in
            let name = url.lastPathComponent
            guard suffix.count < name.count else { return nil }
            guard name.hasSuffix(suffix) else { return nil }
            guard fileManager.isReadableNotDirectory(atPath: url.path) else { return nil }
            return name
        }
    }
}
