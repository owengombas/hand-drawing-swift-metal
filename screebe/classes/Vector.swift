//
//  Vector.swift
//  screebe
//
//  Created by Owen on 01.08.19.
//  Copyright © 2019 daven. All rights reserved.
//

import Foundation
import UIKit

class Vector {
    var startVertex: Vertex? {
        didSet {
            computePos()
        }
    }
    var endVertex: Vertex? {
        didSet {
            computePos()
        }
    }
    var x: Float!
    var y: Float!
    
    var norm: Float {
        return sqrt(pow(x, 2) + pow(y, 2))
    }
    
    init(_ startVertex: Vertex, _ endVertex: Vertex) {
        self.startVertex = startVertex
        self.endVertex = endVertex
        computePos()
    }
    
    init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
    
    func angle(with: Vector) -> Float {
        return acos(abs(scalarProduct(with: with) / (norm * with.norm)))
    }
    
    func angleDeg(with: Vector) -> Float {
        return 180 / Float.pi * angle(with: with)
    }
    
    func scalarProduct(with: Vector) -> Float {
        return x * with.x + y * with.y
    }
    
    func normalize() -> Vector {
        let out = Vector(x, y)
        out.x /= norm
        out.y /= norm
        return out
    }
    
    func rotatePerp() -> Vector {
        let out = Vector(x, y)
        out.x = -y
        out.y = x
        return out
    }
    
    func addVector(_ vector: Vector) -> Vector {
        let out = Vector(x, y)
        out.x += vector.x
        out.y += vector.y
        return out
    }
    
    func substractVector(_ vector: Vector) -> Vector {
        let out = Vector(x, y)
        out.x -= vector.x
        out.y -= vector.y
        return out
    }
    
    func addXY(_ number: Float) -> Vector {
        let out = Vector(x, y)
        out.x += number
        out.y += number
        return out
    }
    
    func substractXY(_ number: Float) -> Vector {
        return addXY(-number)
    }
    
    func scale(_ by: Float) -> Vector {
        let out = Vector(x, y)
        out.x *= by
        out.y *= by
        return out
    }
    
    func reverse() -> Vector {
        return scale(-1)
    }
    
    func divide(_ by: Float) -> Vector {
        return scale(1 / by)
    }
    
    func copy() -> Vector {
        return Vector(x, y)
    }
    
    func toVertex() -> Vertex {
        return Vertex(position: [
            x,
            y
        ])
    }
    
    private func computePos() {
        if startVertex != nil && endVertex != nil {
            x = endVertex!.position.x - startVertex!.position.x
            y = endVertex!.position.y - startVertex!.position.y
        }
    }
}
