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
        let stepX = self.bounds.width / 20

        NSColor.white.setFill()
        self.bounds.fill()

        var stacked = [CGFloat](repeating: 0.0, count: 20)

        for series in 0..<series_count {
            NSColor.white.setStroke()
            NSColor(hue: (0.3 * CGFloat(series+1)).truncatingRemainder(dividingBy: 1.0), saturation: 0.5, brightness: 0.9, alpha: 0.5).setFill()

            let path = NSBezierPath()
            path.move(to: NSPoint(x: self.bounds.minX, y: self.bounds.minY))

            let left: Int, right: Int
            if data_count < 20 {
                left = 0
                right = data_count
            } else {
                left = data_count - 20
                right = data_count
            }
            for i in left..<right {
                let val = self.datasource!.plotPoint(self, series: series, interval: i)
                stacked[i - left] += val
            }
            let maxValue = stacked.max()!

            print("series \(series) stacked=\(stacked)")

            if maxValue > 0.0 {
                for (i, val) in stacked.enumerated() {
                    path.line(to: NSPoint(x: self.bounds.minX + stepX * CGFloat(i),
                                          y: factorY * (val / maxValue)))
                }
                path.stroke()
            }

            path.line(to: NSPoint(x: self.bounds.minX + stepX * CGFloat(20 - 1), y: self.bounds.minY))
            path.fill()
        }

        for x in 0..<20 {
            let pattern: [CGFloat] = [ 1.0, 2.0 ]
            let path = NSBezierPath()
            NSColor.lightGray.setStroke()
            path.setLineDash(pattern, count: pattern.count, phase: 0.0)
            path.move(to: NSPoint(x: CGFloat(x) * stepX, y: self.bounds.minY))
            path.line(to: NSPoint(x: CGFloat(x) * stepX, y: self.bounds.maxY))
            path.stroke()
        }
    }
}
