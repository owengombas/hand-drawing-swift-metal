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
    var vertices: [Vertex] = []
    var triangleVertices: [Vertex] = []
    var flows: [Int] = []
    var minimumNorm: Float = 2
    var minimumNormKeyVertex: Float = 0
    var minimumAngle: Float = 0.15
    var interpolationDivider: Float = 8 // Higher -> use more RAM
    private var _keyVertices: [Vertex] = []
    private var _interpolationPipelineState: MTLComputePipelineState!
    private var _device: MTLDevice!
    private var _lastTriangle: Triangle?
    private var _vertexToAdd: Vertex?
    
    init() {
        stop()
    }
    
    func addKeyVertex(_ vertex: Vertex) {
        var normOkay = true
        
        if _keyVertices.count >= 2 {
            normOkay = Vector(getKeyVertex(0)!, vertex).norm > minimumNormKeyVertex
        }
        
        if normOkay {
            if _keyVertices.count >= 4 {
                _keyVertices.remove(at: 0)
            }
            _keyVertices.append(vertex)
            
            if (_keyVertices.count >= 3) {
                let interpolationB = getKeyVertex(1)!
                let interpolationA = getKeyVertex(2) ?? interpolationB
                let beforeInterpolation = getKeyVertex(3) ?? vertex
                
                interpolateCatmullRom(
                    beforeInterpolation,
                    interpolationA,
                    interpolationB,
                    vertex
                )
            }
        }
    }
    
    func stop() {
        let nb = vertices.count - 1

        if flows.last != nb {
            flows.append(nb)
        }

        if _lastTriangle != nil {
            addTriangleVertices(_lastTriangle!.calculateEndRightTriangle())
        }

        _keyVertices.removeAll()
        _lastTriangle = nil
    }
    
    private func add(_ vertex: Vertex, _ index: Int? = nil) {
        var normOkay = true
        let angleOkay = true

        if let previousVertex = getVertex(0) {
            let vBC = Vector(previousVertex, vertex)
            normOkay = vBC.norm >= minimumNorm

            // It blocks the drawing
//            if let beforePreviousVertex = getVertex(1) {
//                let vBA = Vector(vertex, beforePreviousVertex)
//                angleOkay = vBA.angleDeg(with: vBC) >= minimumAngle
//                print(vBA.angleDeg(with: vBC))
//            }
        }

        if normOkay && angleOkay {
            vertices.append(vertex)
            
            if _lastTriangle != nil {
                addTriangleVertices(_lastTriangle!.calculateJoinTriangle(newVertex: vertex))
            }
            
            if
                let previousVertex = getVertex(2),
                let concernedVertex = getVertex(1)
            {
                let newFlow = _lastTriangle == nil
                
                _lastTriangle = Triangle(
                    previousVertex: previousVertex,
                    centerVertex: concernedVertex,
                    nextVertex: vertex
                )
                addTriangleVertices(_lastTriangle!.calculateVertices())
                
                // Make a rectangle
                if newFlow {
                    addTriangleVertices(_lastTriangle!.calculateStartRightTriangle())
                }
            }
        }
    }
    
    private func addTriangleVertices(_ vertices: [Vertex]) {
        triangleVertices.append(contentsOf: vertices)
    }
    
    private func getKeyVertex(_ indexFromEnd: Int) -> Vertex? {
        return getArraySafe(_keyVertices, indexFromEnd)
    }
    
    private func getVertex(_ indexFromEnd: Int) -> Vertex? {
        let index = vertices.count - (indexFromEnd + 1)
        let element = getArraySafe(vertices, indexFromEnd)
        return element != nil && index > flows.last! ? element : nil
    }
    
    private func getArraySafe<T>(_ array: [T], _ indexFromEnd: Int) -> T? {
        let index = array.count - (indexFromEnd + 1)
        if array.count >= index && index >= 0 {
            return array[index]
        }
        
        return nil
    }
    
    private func interpolateCatmullRom(_ p0: Vertex, _ p1: Vertex, _ p2: Vertex, _ p3: Vertex) {
        let vBC = Vector(p1, p2)
        let vBA = Vector(p1, p0)
        let angle = vBA.angleDeg(with: vBC)
        
        // More points when the angle is bigger
        let to = ((vBC.norm / interpolationDivider) * (1 + angle / 10)).rounded(.up)

        var i: Float = to
        while i >= 0 {
            let t = 1 - i / to
            
            let x = catmullRom(t, p0.position.x, p1.position.x, p2.position.x, p3.position.x)
            let y = catmullRom(t, p0.position.y, p1.position.y, p2.position.y, p3.position.y)
            
            var vertex = p1
            vertex.position = [x, y]
            add(vertex)

            i -= 1
        }
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
