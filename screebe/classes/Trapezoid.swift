//
//  Vector.swift
//  screebe
//
//  Created by Owen on 01.08.19.
//  Copyright © 2019 daven. All rights reserved.
//

import Foundation
import UIKit

class Trapezoid {
    let startVertex: Vertex
    let endVertex: Vertex

    var startTopX: Float {
        return startVertex.position.x
    }
    
    var startTopY: Float {
        return startVertex.position.y
    }
    
    var startBottomX: Float {
        return startVertex.position.x
    }
    
    var startBottomY: Float {
        return startVertex.position.y
    }
    
    var endTopX: Float {
        return endVertex.position.x
    }
    
    var endTopY: Float {
        return endVertex.position.y
    }
    
    var endBottomX: Float {
        return endVertex.position.x
    }
    
    var endBottomY: Float {
        return endVertex.position.y
    }

    init(_ startVertex: Vertex, _ endVertex: Vertex) {
        self.startVertex = startVertex
        self.endVertex = endVertex
    }
}
