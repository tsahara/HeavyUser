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

    var currentAct: [Substring:(UInt64, UInt64)] = [:]
    var procindex: [Substring:Int] = [:]
    var tick = 0

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
            let str = String(data: handle.availableData, encoding: String.Encoding.ascii)!
            let lines = str.split(separator: "\n")
            for line in lines {
                let csv = line.split(separator: ",")
                if csv[0] == "time" {
                    var acts: [Int:(Substring, UInt64, UInt64)] = [:]
                    for (process, (in_bytes, out_bytes)) in self.currentAct {
                        acts[self.procindex[process]!] = (process, in_bytes, out_bytes)
                    }

                    for i in 0..<self.procindex.count {
                        print("\(i) => \(acts[i])")
                    }

                    self.tick += 1
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
        return 6
    }

    func plotPoint(_ plotView: PlotView, series: Int, interval: Int) -> CGFloat {
        return 3
    }
}
