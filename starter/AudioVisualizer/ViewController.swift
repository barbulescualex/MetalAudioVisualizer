//
//  ViewController.swift
//  AudioVisualizer
//
//  Created by Alex Barbulescu on 2019-04-06.
//  Copyright © 2019 alex. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let audioVisualizer = AudioVisualizer()
        view.addSubview(audioVisualizer)
        
        //constraining to window
        audioVisualizer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        audioVisualizer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        audioVisualizer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        audioVisualizer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }

}
