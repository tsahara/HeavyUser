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
    func numberOfSeries(in: PlotView) -> Int
    func plotPoint(_ plotView: PlotView, series: Int, interval: Int) -> CGFloat
}

class PlotView : NSView {
    var datasource: PlotViewDataSource?

    override func draw(_ dirtyRect: NSRect) {
        guard datasource != nil else {
            return
        }

        let data_count = self.datasource!.numberOfPoints(in: self)
        guard data_count > 0 else {
            return
        }

        let series_count = self.datasource!.numberOfSeries(in: self)
        guard series_count > 0 else {
            return
        }

        let factorY = self.bounds.height * 0.9
        let stepX = self.bounds.width / CGFloat(data_count)

        NSColor.white.setFill()
        self.bounds.fill()

        NSColor.white.setStroke()
        NSColor(hue: 0.3, saturation: 0.5, brightness: 0.9, alpha: 0.5).setFill()

        let path = NSBezierPath()
        path.move(to: NSPoint(x: self.bounds.minX, y: self.bounds.minY))

        var values: [CGFloat] = []
        for i in 0..<data_count {
            values.append(self.datasource!.plotPoint(self, series: 0, interval: i))
        }
        let maxValue = values.max()!
        if maxValue == 0.0 {
            return
        }

        for (i, val) in values.enumerated() {
            path.line(to: NSPoint(x: self.bounds.minX + stepX * CGFloat(i),
                                  y: factorY * (val / maxValue)))
        }
        path.stroke()

        path.line(to: NSPoint(x: self.bounds.minX + stepX * CGFloat(data_count - 1), y: self.bounds.minY))
        path.fill()
    }
}
