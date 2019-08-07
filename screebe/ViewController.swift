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
    private var _renderer: Renderer!
    private var _mtkView: MTKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _mtkView = self.view as? MTKView
        _mtkView.device = MTLCreateSystemDefaultDevice()

        _mtkView.clearColor = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        _mtkView.isOpaque = false

        _renderer = Renderer(_mtkView)
        _mtkView.delegate = _renderer
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _renderer.touched(touches, event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        _renderer.touched(touches, event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _renderer.touched(touches, event)
        _renderer.endTouch()
    }
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        // _renderer.touched(touches, nil)
    }
}
