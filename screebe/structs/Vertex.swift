//
//  Vertex.swift
//  screebe
//
//  Created by Owen on 01.08.19.
//  Copyright © 2019 daven. All rights reserved.
//

import Foundation
import MetalKit

struct Vertex {
    var position: vector_float2
    var color: float4 = [0, 0, 0, 1]
    var pointSize: Float = 10
    
    init(position: vector_float2) {
        self.position = position
    }
    
    init(position: vector_float2, pointSize: Float) {
        self.position = position
        self.pointSize = pointSize / 2
    }
    
    init(position: vector_float2, color: float4, pointSize: Float) {
        self.position = position
        self.pointSize = pointSize / 2
        self.color = color
    }
    
    func toVector() -> Vector {
        return Vector(position.x, position.y)
    }
}
