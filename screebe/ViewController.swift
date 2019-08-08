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
