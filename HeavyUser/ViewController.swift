//
//  ViewController.swift
//  HeavyUser
//
//  Created by Tomoyuki Sahara on 2017/09/26.
//  Copyright © 2017 Tomoyuki Sahara. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var plotView: PlotView!

    var process: Process?
    var pipe: Pipe?

    var procmap: [Substring: Int] = [:]
    var proc_index_next = 0

    var act: [[(UInt64, UInt64)]] = []
    var currentAct: [Substring:(UInt64, UInt64)]
    var tick = 0

    override func viewDidLoad() {
        super.viewDidLoad()

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
                    for (process, bytes) in self.currentAct {

                    }
                    
                    self.tick += 1
                } else {
                    let process   = csv[1]
                    let bytes_in  = UInt64(String(csv[3]))!
                    let bytes_out = UInt64(String(csv[4]))!
                    
                    self.currentAct[process] = (bytes_in, bytes_out)

                    if self.procmap[process] == nil {
                        self.procmap[process] = self.proc_index_next
                        self.proc_index_next += 1
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


}

