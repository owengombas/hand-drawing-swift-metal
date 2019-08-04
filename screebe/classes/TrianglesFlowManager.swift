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
    var triangleVertices: [Vertex] = []
    var keyVertices: [Vertex] = []
    var flows: [Int] = []
    private var lastTriangle: Triangle?
    private var bufferLength = 200
    private var minimalNorm: Float = 0.5
    
    init() {
        stop()
    }
    
    func addKeyVertex(_ lastVertex: Vertex, _ interpolate: Bool = false) {
        if let concernedVertex = getKeyVertex(1) {
            let vBC = Vector(concernedVertex, lastVertex)
            if vBC.norm >= minimalNorm {
                if let previousVertex = getKeyVertex(2) {
                    if lastTriangle != nil {
                        if lastTriangle!.computed {
                            triangleVertices.append(
                                contentsOf: lastTriangle!.calculateJoinTriangle(newVertex: lastVertex)
                            )
                        }
                    }
                    
                    lastTriangle = Triangle(
                        previousVertex: previousVertex,
                        centerVertex: concernedVertex,
                        nextVertex: lastVertex
                    )
                    
                    triangleVertices.append(contentsOf: lastTriangle!.calculateVertices())
                    
//                    if keyVertices.count % bufferLength == 0 && keyVertices.count > 0 {
//                        processBuffer()
//                    }
                }
                keyVertices.append(lastVertex)
            }
        } else {
            keyVertices.append(lastVertex)
        }
    }
    
    func stop() {
        if lastTriangle != nil {
            rightTriangle()
            lastTriangle = nil
        }

        let nb = keyVertices.count - 1
        if flows.last != nb || flows.last == nil {
            flows.append(nb)
        }
    }
    
    private func rightTriangle() {
        triangleVertices.append(contentsOf: lastTriangle!.calculateEndRightTriangle())
    }
    
    private func getKeyVertex(_ indexFromEnd: Int) -> Vertex? {
        if keyVertices.count >= indexFromEnd && keyVertices.count - indexFromEnd > flows.last! {
            return keyVertices[keyVertices.count - indexFromEnd]
        }

        return nil
    }
    
    private func processBuffer() {
        // MUST RECALCULATE THE TRIANGLES
        let end = keyVertices.count - bufferLength + 2
        var i = keyVertices.count - 1
        while i >= end {
            let vertexA = keyVertices[i]
            var j = i - 1
            while j >= end - 1 {
                let vertexB = keyVertices[j]
                let vAB = Vector(vertexA, vertexB)
                if vAB.norm < 1 {
                    let total = j * 6 - 1
                    triangleVertices.removeSubrange(total - 3...total)
                    keyVertices.remove(at: j)
                    i -= 1
                    break
                }
                j -= 1
            }
            i -= 1
        }
    }
    
    private func interpolate(_ p1: Vertex, _ p2: Vertex, _ p3: Vertex) {
        let vBC = Vector(p2, p3)
        for i in 0...Int((vBC.norm / 3).rounded(.up)) {
            let x = p2.position.x + Float(i)
            let y = quadInterpolation(x, p1, p2, p3)
            addKeyVertex(Vertex(position: [x, y]), false)
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
        let c = p2 - p0 * t
        let d = 2 * p1
        let final = (a * pow(t, 3) + b * pow(t, 2) + c + d)
        return 0.5 * final
    }
    
    private func catmullRom2D(_ t: Float, _ p0: Vertex, _ p1: Vertex, _ p2: Vertex, _ p3: Vertex) -> Vertex {
        let x = catmullRom(t, p0.position.x, p1.position.x, p2.position.x, p3.position.x)
        let y = catmullRom(t, p0.position.y, p1.position.y, p2.position.y, p3.position.y)
        return Vertex(position: [x, y], color: [0, 0, 0, 1], pointSize: 4)
    }
}
