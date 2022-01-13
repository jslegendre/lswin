//
//  main.swift
//  
//
//  Created by Jeremy on 1/13/22.
//

import Foundation

let fileManager = FileManager.default
if fileManager.fileExists(atPath: "/usr/local/bin/lswin") {
    try fileManager.removeItem(atPath: "/usr/local/bin/lswin")
}
