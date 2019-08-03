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
    private var lastTriangle: Triangle?
    
    init() {
    }
    
    func addKeyVertex(_ lastVertex: Vertex) {
        var previousVertex: Vertex?
        if (keyVertices.count >= 2) {
            previousVertex = keyVertices[keyVertices.count - 2]
        }
        let concernedVertex = keyVertices.last
        keyVertices.append(lastVertex)
        
        if (previousVertex != nil && concernedVertex != nil) {
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

            if (lastTriangle!.vAB.norm > 1 && lastTriangle!.vBC.norm > 1) || keyVertices.count < 4 {
                triangleVertices.append(contentsOf: lastTriangle!.calculateVertices())
            } else {
                keyVertices.remove(at: keyVertices.count - 1)
            }
        }
    }
}
