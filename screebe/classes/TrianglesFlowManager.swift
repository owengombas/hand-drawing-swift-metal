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
    
    func addKeyVertex(_ lastVertex: Vertex) {
        var previousVertex: Vertex?
        var concernedVertex: Vertex?
        if (keyVertices.count >= 1) {
            concernedVertex = getKeyVertex(keyVertices.count - 1)
        }
        if (keyVertices.count >= 2) {
            previousVertex = getKeyVertex(keyVertices.count - 2)
        }

        if concernedVertex != nil {
            let vBC = Vector(concernedVertex!, lastVertex)
            if vBC.norm >= minimalNorm {
                keyVertices.append(lastVertex)
                if previousVertex != nil {
                    let firstVertex = lastTriangle == nil
                    if lastTriangle != nil {
                        if lastTriangle!.computed {
                            triangleVertices.append(
                                contentsOf: lastTriangle!.calculateJoinTriangle(newVertex: lastVertex)
                            )
                        }
                    }
                    
                    lastTriangle = Triangle(
                        previousVertex: previousVertex!,
                        centerVertex: concernedVertex!,
                        nextVertex: lastVertex
                    )
                    
                    if firstVertex {
                    }
                    
                    triangleVertices.append(contentsOf: lastTriangle!.calculateVertices())
                    
//                    if keyVertices.count % bufferLength == 0 && keyVertices.count > 0 {
//                        processBuffer()
//                    }
                }
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
    
    private func getKeyVertex(_ index: Int) -> Vertex? {
        if index > flows.last! {
            return keyVertices[index]
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
}
