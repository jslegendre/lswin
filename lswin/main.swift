/*
 *  Copyright (c) 2022 Jeremy Legendre. All rights reserved.
 *
 *  Released under "The GNU General Public License (GPL-2.0)"
 *
 *  This program is free software; you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License as published by the
 *  Free Software Foundation; either version 2 of the License, or (at your
 *  option) any later version.
 *
 *  This program is distributed in the hope that it will be useful, but
 *  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 *  or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
 *  for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 */

import Foundation
import ArgumentParser

struct Window: Identifiable, Comparable {
    var id: CGWindowID = 0
    var name: String = ""
    var owner: String = ""
    var ownerPid: pid_t = 0
    var origin: CGPoint = CGPoint(x: 0, y: 0)
    var size: CGSize = CGSize(width: 0, height: 0)
    var isOnScreen: Bool = false
    var isMenuBarItem: Bool = false
    
    private func basicDescription() -> String {
        return String(format: "%-6u %@\t%@", id, name.padding(toLength: 30, withPad: " ", startingAt: 0),
                      owner.padding(toLength: 30, withPad: " ", startingAt: 0))
    }
    
    private func verboseDescription() -> String {
        let pidDesc = String(format: "pid %d", ownerPid)
        let originString = String(format: "Origin: (%.2f, %.2f)", origin.x, origin.y)
        let sizeString = String(format: "Size: (%.2f, %.2f)", size.width, size.height)
        let isOnScreenDesc = String(format: "Is On Screen: %@", isOnScreen ? "Yes" : "No")
        let isMenuBarItemDesc = String(format: "Is Menu Item: %@", isMenuBarItem ? "Yes" : "No")
        return String(format: " +- %u\n |+- %@\n |+- %@\n |+- %@\n |+- %@\n |+- %@\n |+- %@\n |+- %@\n",
                      id, name, owner, pidDesc, originString, sizeString,
                      isOnScreenDesc, isMenuBarItemDesc)
    }
    
    func description(verbose: Bool = false) -> String {
        if verbose {
            return verboseDescription()
        }
        
        return basicDescription()
    }
    
    init(windowInfo: Dictionary<String, Any?>) {
        if let windowId = windowInfo["kCGWindowNumber"] {
            self.id = (windowId as! UInt32)
        }
        
        if let windowName = windowInfo["kCGWindowName"] {
            name = (windowName as! String)
        }
        
        if let owner = windowInfo["kCGWindowOwnerName"] {
            self.owner = (owner as! String)
        }
        
        if let ownerPid = windowInfo["kCGWindowOwnerPID"] {
            self.ownerPid = ownerPid as! Int32
        }
        
        if let windowBounds = windowInfo["kCGWindowBounds"] {
            let frame = CGRect(dictionaryRepresentation: (windowBounds as! CFDictionary))
            if let frame = frame {
                origin = frame.origin
                size = frame.size
            }
        }
        
        if let isOnScreen = windowInfo["kCGWindowIsOnscreen"] {
            self.isOnScreen = isOnScreen as! CBool
        }
        
        if let windowLayer = windowInfo["kCGWindowLayer"] {
            self.isMenuBarItem = (windowLayer as! UInt32) == 25
        }
    }
    
    static func <(lhs: Window, rhs: Window) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func >(lhs: Window, rhs: Window) -> Bool {
        return lhs.id > rhs.id
    }
    
    static func ==(lhs: Window, rhs: Window) -> Bool {
        return lhs.id == rhs.id
    }
}

struct WindowManager {
    public private(set) var windows: [Window] = []
    
    init(allWindows: Bool) {
        var options = CGWindowListOption(rawValue: CGWindowListOption.optionOnScreenOnly.rawValue | CGWindowListOption.excludeDesktopElements.rawValue)
        
        if allWindows {
            options = CGWindowListOption(rawValue: CGWindowListOption.optionAll.rawValue | CGWindowListOption.excludeDesktopElements.rawValue)
        }
        let windowList = CGWindowListCopyWindowInfo(options, 0) as Array?
        if let windowList = windowList {
            windows = windowList.map { Window(windowInfo: ($0 as! Dictionary<String, Any?>)) }
            windows.sort()
        }
    }
}

struct lswin: ParsableCommand {
    @Flag(name: [.customShort("v"), .long], help: "Print additional window information")
    var verbose: Bool = false
    
    @Flag(name: [.customShort("a"), .long], help: "Show information for all windows (including offscreen)")
    var all: Bool = false
    
    @Option(name: [.customShort("p"), .long], help: "Only show windows belonging to process named <process> (case insensitive)")
    var process: String?
    
    @Flag(help: "Filter out menubar items") var noMenubarItems = false
    
    func printWindowList() {
        let manager = WindowManager(allWindows: all)
        var windows = manager.windows

        if noMenubarItems {
            windows = windows.filter { !$0.isMenuBarItem }
        }
        
        if let process = process {
            windows = windows.filter { $0.owner.lowercased() == process.lowercased() }
        }
        
        for window in windows {
            print(window.description(verbose: verbose))
        }
    }
    
    func run() {
        let hasPermissions = CGPreflightScreenCaptureAccess()
        guard hasPermissions else {
            print("lswin requires screen capture permissions to collect window information")
            CGRequestScreenCaptureAccess();
            return
        }
        printWindowList()
    }
}

lswin.main()
