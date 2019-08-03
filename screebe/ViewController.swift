//
//  ViewController.swift
//  screebe
//
//  Created by Owen on 31.07.19.
//  Copyright © 2019 daven. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    var renderer: Renderer!
    var mtkView: MTKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mtkView = self.view as? MTKView
        mtkView.device = MTLCreateSystemDefaultDevice()

        mtkView.clearColor = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        mtkView.isOpaque = false

        renderer = Renderer(mtkView)
        mtkView.delegate = renderer
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.touched(touches, event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.touched(touches, event)
    }
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        // renderer.touched(touches, nil)
    }
}
