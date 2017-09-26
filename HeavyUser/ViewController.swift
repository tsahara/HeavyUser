//
//  ViewController.swift
//  HeavyUser
//
//  Created by Tomoyuki Sahara on 2017/09/26.
//  Copyright © 2017 Tomoyuki Sahara. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var process: Process?
    var pipe: Pipe?

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
            FileHandle.standardOutput.write(handle.availableData)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

