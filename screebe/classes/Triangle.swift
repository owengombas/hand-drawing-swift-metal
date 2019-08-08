//
//  Triangle.swift
//  screebe
//
//  Created by Owen on 02.08.19.
//  Copyright © 2019 daven. All rights reserved.
//

import Foundation

class Triangle {
    private var _vAB: Vector
    private var _vBC: Vector
    private var _computed: Bool = false
    var previousVertex: Vertex
    var nextVertex: Vertex
    var centerVertex: Vertex
    var aVertex: Vertex?
    var bVertex: Vertex?
    var cVertex: Vertex?

    var computed: Bool {
        return _computed
    }
    var vAB: Vector {
        return _vAB
    }
    var vBC: Vector {
        return _vBC
    }
    
    init(
        previousVertex: Vertex,
        centerVertex: Vertex,
        nextVertex: Vertex
    ) {
        self.previousVertex = previousVertex
        self.centerVertex = centerVertex
        self.nextVertex = nextVertex
        _vAB = Vector(previousVertex, centerVertex)
        _vBC = Vector(centerVertex, nextVertex)
    }
    
    func calculateVertices() -> [Vertex] {
        //                      c
        //       / \‾‾‾‾‾‾‾‾‾‾‾/ \‾‾‾‾‾‾‾‾‾‾‾/ \
        //      /   \         /   \         /   \
        //     /  OA \   -   /  OB \   -   /  OC \
        //    /       \     /   |   \     /       \
        //   /_________\ a /____|____\ b /_________\
        //
        // OA is previousVertex
        // OB is centerVertex
        // OC is lastVertex

        let vOB = centerVertex.toVector()
        
        let vnAB = _vAB.rotatePerp().normalize()
        let vnBC = _vBC.rotatePerp().normalize()
        
        let vBc = vnAB.addVector(vnBC).normalize().scale(centerVertex.pointSize)
        
        aVertex = vOB
            .substractVector(vAB.divide(2))
            .substractVector(vnAB.scale(centerVertex.pointSize))
            .toVertex()
        bVertex = vOB
            .addVector(vBC.divide(2))
            .substractVector(vnBC.scale(centerVertex.pointSize))
            .toVertex()
        cVertex = vOB.addVector(vBc).toVertex()
        
        _computed = true
        
        return [aVertex!, bVertex!, cVertex!]
    }
    
    func calculateJoinTriangleVertex(newVertex: Vertex) -> Vertex {
        let vOC = nextVertex.toVector()
        let vBC = Vector(centerVertex, nextVertex)
        let vCD = Vector(nextVertex, newVertex)
        
        let vnBC = vBC.rotatePerp().normalize()
        let vnCD = vCD.rotatePerp().normalize()
        
        let vCc = vnBC.addVector(vnCD).normalize().scale(nextVertex.pointSize)
        
        let dVertex = vOC.addVector(vCc).toVertex()
        
        return dVertex
    }
    
    func calculateEndRightTriangle() -> Vertex {
        let vSemiba = Vector(bVertex!, aVertex!).divide(2)
        let vSemibac = Vector(
            vSemiba.addVector(bVertex!.toVector()).toVertex(),
            cVertex!
        )
        let dVertex = Vertex(position: [
            cVertex!.position.x - vSemiba.x,
            bVertex!.position.y + vSemibac.y
        ])
        
        return dVertex
    }
    
    func calculateStartRightTriangle() -> Vertex {
        let vSemiab = Vector(aVertex!, bVertex!).divide(2)
        let vSemiabc = Vector(
            vSemiab.addVector(aVertex!.toVector()).toVertex(),
            cVertex!
        )
        let dVertex = Vertex(position: [
            cVertex!.position.x - vSemiab.x,
            aVertex!.position.y + vSemiabc.y
        ])
        
        return dVertex
    }
}
