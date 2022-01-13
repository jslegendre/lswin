//
//  main.swift
//  
//
//  Created by Jeremy on 1/13/22.
//

import Foundation

let build = Process()
build.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
build.arguments = ["build", "-c", "release"]
try build.run()
build.waitUntilExit()

let fileManager = FileManager.default
if fileManager.fileExists(atPath: "/usr/local/bin/lswin") {
    try fileManager.removeItem(atPath: "/usr/local/bin/lswin")
}

try fileManager.copyItem(atPath: ".build/release/lswin", toPath: "/usr/local/bin/lswin")
