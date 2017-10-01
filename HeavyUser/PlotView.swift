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

protocol PlotViewDataSource {
    func numberOfPoints(in: PlotView) -> Int
    func plotPoint(_ plotView: PlotView, series: Int, interval: Int) -> CGFloat
}

class PlotView : NSView {
    let data: [Int] = [ 1, 5, 2, 6, 3 ]
    var datasource: PlotViewDataSource?

    override func draw(_ dirtyRect: NSRect) {
        guard datasource != nil else {
            return
        }

        let data_count = self.datasource!.numberOfPoints(in: self)

        let maxValue = data.max()!
        let factorY = self.bounds.height * 0.9
        let stepX = self.bounds.width / CGFloat(data_count)

        NSColor.white.setFill()
        self.bounds.fill()

        NSColor.white.setStroke()
        NSColor(hue: 0.3, saturation: 0.3, brightness: 0.9, alpha: 1.0).setFill()

        let path = NSBezierPath()
        path.move(to: NSPoint(x: self.bounds.minX, y: self.bounds.minY))

        for i in 0..<data_count {
            let value = self.datasource!.plotPoint(self, series: 0, interval: i)
            path.line(to: NSPoint(x: self.bounds.minX + stepX * CGFloat(i),
                                  y: factorY * (CGFloat(value) / CGFloat(maxValue))))
        }
        path.stroke()
        path.line(to: NSPoint(x: self.bounds.minX + stepX * CGFloat(data_count - 1), y: self.bounds.minY))
        path.fill()
    }
}
