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
    let data: [Int] = [ 1, 5, 2, 6, 3 ]

    override func draw(_ dirtyRect: NSRect) {
        let maxValue = data.max()!
        let factorY = self.bounds.height * 0.9
        let stepX = self.bounds.width / CGFloat(data.count)

        NSColor.white.setFill()
        self.bounds.fill()

        NSColor.white.setStroke()
        NSColor(hue: 0.3, saturation: 0.3, brightness: 0.9, alpha: 1.0).setFill()
        let path = NSBezierPath()
        path.move(to: NSPoint(x: self.bounds.minX, y: self.bounds.minY))
        for i in 0..<data.count {
            let value = self.data[i]
            path.line(to: NSPoint(x: self.bounds.minX + stepX * CGFloat(i),
                                  y: factorY * (CGFloat(value) / CGFloat(maxValue))))
        }
        path.stroke()
        path.line(to: NSPoint(x: self.bounds.minX + stepX * CGFloat(data.count - 1), y: self.bounds.minY))
        path.fill()
    }
}
