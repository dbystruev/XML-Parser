//
//  RootTableViewController.swift
//  XML Parser
//
//  Created by Denis Bystruev on 08/09/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {
    
    // MARK: - Stored Properties
    let bundleManager = BundleManager()
    let fileExtension = "xml"
    
    var content = ""
    var elementLevel = 0
    var elements = Set<String>()
    var fileNames = [String]()
    var printContent = false
    
    // MARK: - Computed Properties
    var elementTabs: String {
        return String(repeating: "\t", count: elementLevel)
    }
    
    // MARK: - Custom Methods
    func printRemainingString() {
        guard printContent else {
            content = ""
            return
        }
        if content.isEmpty {
            print()
        } else {
            print(": \(content)")
            content = ""
        }
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileNames = bundleManager.getFileNames(with: fileExtension)
        print(#line, #function, fileNames)
        
        for fileName in fileNames {
            let url = Bundle.main.url(forResource: fileName, withExtension: nil)
            
            guard let xmlURL = url else {
                print(#line, #function, "ERROR: Can't find \(fileName) in main bundle")
                return
            }
            
            guard let parser = XMLParser(contentsOf: xmlURL) else {
                print(#line, #function, "ERROR: Can't parse XML file at \(xmlURL.path)")
                return
            }
            
            parser.delegate = self
//            parser.parse()
        }
    }
}

// MARK: - XMLParserDelegate
extension RootTableViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if !elements.contains(elementName) {
            elements.insert(elementName)
            printRemainingString()
            print("\(elementTabs)\(elementName)", terminator: "")
            for (attribute, value) in attributeDict {
                print(" \(attribute)=\"\(value)\"", terminator: "")
            }
            printContent = true
        }
        elementLevel += 1
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        printRemainingString()
        printContent = false
        elementLevel -= 1
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        content = "\(content)\(trimmedString)"
    }
}

// MARK: - UITableViewDataSource
extension RootTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = fileNames[indexPath.row]
        return cell
    }
}
