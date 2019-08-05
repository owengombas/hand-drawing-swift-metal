//
//  TrianglesFlowManager.swift
//  screebe
//
//  Created by Owen on 02.08.19.
//  Copyright © 2019 daven. All rights reserved.
//

import Foundation
import MetalKit

class TrianglesFlowManager {
    var keyVertices: [Vertex] = []
    var flows: [Int] = []
    private var _interpolationPipelineState: MTLComputePipelineState!
    private var _minimalNorm: Float = 0.5
    private var _device: MTLDevice!
    
    init() {
        stop()
    }
    
    func addKeyVertex(_ lastVertex: Vertex, _ interpolate: Bool = true) {
        if let concernedVertex = getKeyVertex(1) {
            let vBC = Vector(concernedVertex, lastVertex)
            if interpolate {
                if vBC.norm >= _minimalNorm {
                    let previousVertex = getKeyVertex(2) ?? concernedVertex
                    let previousPreviousVertex = getKeyVertex(3) ?? previousVertex
                    interpolateCatmullRom(previousPreviousVertex, previousVertex, concernedVertex, lastVertex)
                    keyVertices.append(lastVertex)
                }
            } else {
                keyVertices.insert(lastVertex, at: 0)
            }
        } else {
            keyVertices.append(lastVertex)
        }
    }
    
    func stop() {
        let nb = keyVertices.count - 1
        if flows.last != nb || flows.last == nil {
            flows.append(nb)
        }
    }
    
    private func getKeyVertex(_ indexFromEnd: Int) -> Vertex? {
        if keyVertices.count >= indexFromEnd && keyVertices.count - indexFromEnd > flows.last! {
            return keyVertices[keyVertices.count - indexFromEnd]
        }

        return nil
    }

    private func interpolateQuad(_ p1: Vertex, _ p2: Vertex, _ p3: Vertex) {
        let vBC = Vector(p2, p3)
        for i in 0...Int((vBC.norm / 3).rounded(.up)) {
            let x = p2.position.x + Float(i)
            let y = quadInterpolation(x, p1, p2, p3)
            addKeyVertex(Vertex(position: [x, y], color: [1, 0, 0, 1], pointSize: 10), false)
        }
    }
    
    private func interpolateCatmullRom(_ p0: Vertex, _ p1: Vertex, _ p2: Vertex, _ p3: Vertex) {
        let vBC = Vector(p1, p2)
        let to = (vBC.norm / 5).rounded(.up)
        var i: Float = 1
    
        while i < to {
            let t = i / to
            let x = catmullRom(t, p0.position.x, p1.position.x, p2.position.x, p3.position.x)
            let y = catmullRom(t, p0.position.y, p1.position.y, p2.position.y, p3.position.y)
            addKeyVertex(Vertex(position: [x, y], color: [1, 0, 0, 1], pointSize: 10), false)
            i += 1
        }
    }
    
    private func quadInterpolation(_ x: Float, _ p1: Vertex, _ p2: Vertex, _ p3: Vertex) -> Float {
        let a = p1.position.y * (x - p2.position.x) * (x - p3.position.x) / ((p1.position.x - p2.position.x) * (p1.position.x - p3.position.x))
        let b = p2.position.y * (x - p1.position.x) * (x - p3.position.x) / ((p2.position.x - p1.position.x) * (p2.position.x - p3.position.x))
        let c = p3.position.y * (x - p1.position.x) * (x - p2.position.x) / ((p3.position.x - p1.position.x) * (p3.position.x - p2.position.x))
        return a + b + c
    }
    
    private func catmullRom(_ t: Float, _ p0: Float, _ p1: Float, _ p2: Float, _ p3: Float) -> Float {
        let a = 3 * p1 - p0 - 3 * p2 + p3
        let b = 2 * p0 - 5 * p1 + 4 * p2 - p3
        let c = (p2 - p0) * t
        let d = 2 * p1
        let final = (a * pow(t, 3) + b * pow(t, 2) + c + d)
        return 0.5 * final
    }
}
