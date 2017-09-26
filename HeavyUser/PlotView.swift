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
    }
}
