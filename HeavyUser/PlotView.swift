//
//  PlotView.swift
//  HeavyUser
//
//  Created by Tomoyuki Sahara on 2017/09/26.
//  Copyright © 2017 Tomoyuki Sahara. All rights reserved.
//

import Foundation
import Cocoa
import AppKit

class PlotView : NSView {
    override func draw(_ dirtyRect: NSRect) {
        NSColor.white.setFill()
        self.bounds.fill()

        NSColor.blue.setFill()
        let path = NSBezierPath()
        path.move(to: NSPoint(x: self.bounds.minX, y: self.bounds.minY))
        path.line(to: NSPoint(x: self.bounds.midX, y: self.bounds.maxY))
        path.line(to: NSPoint(x: self.bounds.maxX, y: self.bounds.minY))
        path.fill()
    }
}
