//
//  Triangle.swift
//  screebe
//
//  Created by Owen on 02.08.19.
//  Copyright © 2019 daven. All rights reserved.
//

import Foundation

class Triangle {
    private var _previousVertex: Vertex
    private var _nextVertex: Vertex
    private var _centerVertex: Vertex
    private var _vAB: Vector
    private var _vBC: Vector
    private var _aVertex: Vertex?
    private var _bVertex: Vertex?
    private var _cVertex: Vertex?
    private var _computed: Bool = false

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
        _previousVertex = previousVertex
        _centerVertex = centerVertex
        _nextVertex = nextVertex
        _vAB = Vector(_previousVertex, _centerVertex)
        _vBC = Vector(_centerVertex, _nextVertex)
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

        let vOB = _centerVertex.toVector()
        
        let vnAB = _vAB.rotatePerp().normalize()
        let vnBC = _vBC.rotatePerp().normalize()
        
        let vBc = vnAB.addVector(vnBC).normalize().scale(_centerVertex.pointSize)
        
        _aVertex = vOB
            .substractVector(vAB.divide(2))
            .substractVector(vnAB.scale(_centerVertex.pointSize))
            .toVertex()
        _bVertex = vOB
            .addVector(vBC.divide(2))
            .substractVector(vnBC.scale(_centerVertex.pointSize))
            .toVertex()
        _cVertex = vOB.addVector(vBc).toVertex()
        
        _computed = true
        
        return [_aVertex!, _bVertex!, _cVertex!]
    }
    
    func calculateJoinTriangle(newVertex: Vertex) -> [Vertex] {
        let vOC = _nextVertex.toVector()
        let vBC = Vector(_centerVertex, _nextVertex)
        let vCD = Vector(_nextVertex, newVertex)
        
        let vnBC = vBC.rotatePerp().normalize()
        let vnCD = vCD.rotatePerp().normalize()
        
        let vCc = vnBC.addVector(vnCD).normalize().scale(_nextVertex.pointSize)
        
        let dVertex = vOC.addVector(vCc).toVertex()
        
        return [_bVertex!, _cVertex!, dVertex]
    }
    
    func calculateEndRightTriangle() -> [Vertex] {
        let vSemiba = Vector(_bVertex!, _aVertex!).divide(2)
        let vSemibac = Vector(
            vSemiba.addVector(_bVertex!.toVector()).toVertex(),
            _cVertex!
        )
        let dVertex = Vertex(position: [
            _cVertex!.position.x - vSemiba.x,
            _bVertex!.position.y + vSemibac.y
        ])
        
        return [_bVertex!, _cVertex!, dVertex]
    }
    
    func calculateStartRightTriangle() -> [Vertex] {
        let vSemiab = Vector(_aVertex!, _bVertex!).divide(2)
        let vSemiabc = Vector(
            vSemiab.addVector(_aVertex!.toVector()).toVertex(),
            _cVertex!
        )
        let dVertex = Vertex(position: [
            _cVertex!.position.x - vSemiab.x,
            _aVertex!.position.y + vSemiabc.y
        ])
        
        return [_aVertex!, _cVertex!, dVertex]
    }
}
