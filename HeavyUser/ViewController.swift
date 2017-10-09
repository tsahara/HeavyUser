//
//  ViewController.swift
//  HeavyUser
//
//  Created by Tomoyuki Sahara on 2017/09/26.
//  Copyright © 2017 Tomoyuki Sahara. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, PlotViewDataSource {
    @IBOutlet weak var plotView: PlotView!

    var process: Process?
    var pipe: Pipe?

    // Process: Substring -> Index: Int
    var procindex: [Substring:Int] = [:]

    var currentAct: [Substring:(UInt64, UInt64)] = [:]

    // history[tick][index] -> a record
    var history: [[(UInt64, UInt64)]] = []

    var tick = 0

    var buffer: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.plotView.datasource = self

        self.pipe = Pipe()
        self.process = Process()

        process!.launchPath = "/usr/bin/nettop"
        process!.arguments = ["-dnPL0"]

        process!.standardOutput = pipe
        process!.launch()

        print(process!.isRunning)

        self.pipe!.fileHandleForReading.readabilityHandler = {
            handle in
            self.buffer += String(data: handle.availableData, encoding: String.Encoding.ascii)!
            var lines = self.buffer.split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: false)

            let last = lines.popLast()!
            self.buffer = String(last)

            for line in lines {
                let csv = line.split(separator: ",")
                if csv[0] == "time" {
                    if self.currentAct.count == 0 {
                        continue
                    }
                    var record = Array(repeating: (UInt64(0), UInt64(0)), count: self.procindex.count)
                    for (process, (in_bytes, out_bytes)) in self.currentAct {
                        record[self.procindex[process]!] = (in_bytes, out_bytes)
                    }
                    self.history.append(record)
                    self.currentAct = [:]
                    self.tick += 1

                    DispatchQueue.main.async {
                        self.plotView.needsDisplay = true
                    }
                } else {
                    let process   = csv[1]
                    let bytes_in  = UInt64(String(csv[3]))!
                    let bytes_out = UInt64(String(csv[4]))!
                    
                    self.currentAct[process] = (bytes_in, bytes_out)

                    if self.procindex[process] == nil {
                        self.procindex[process] = self.procindex.count
                    }
                }
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func numberOfPoints(in: PlotView) -> Int {
        return self.history.count - 1
    }

    func numberOfSeries(in: PlotView) -> Int {
        return self.procindex.count - 1
    }

    func plotPoint(_ plotView: PlotView, series: Int, interval: Int) -> CGFloat {
        if interval >= self.history.count - 1 {
            return 0.0
        }
        if series >= self.history[interval].count {
            return 0.0
        }
        let (in_bytes, out_bytes) = self.history[interval][series]
        return CGFloat(in_bytes + out_bytes)
    }
}
