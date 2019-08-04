//
//  ViewController.swift
//  screebe
//
//  Created by Owen on 31.07.19.
//  Copyright © 2019 daven. All rights reserved.
//

import UIKit
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    private var device: MTLDevice!
    private var commandQueue: MTLCommandQueue!
    private var pipelineState: MTLRenderPipelineState!
    private var pipelineDescriptor: MTLRenderPipelineDescriptor!
    private var vertices: [Vertex]!
    private var joiners: [Vector]!
    private var verticesBuffer: MTLBuffer!
    private var verticesInfosBuffer: MTLBuffer!
    private var fragmentBuffer: MTLBuffer!
    private var view: MTKView!
    private var trianglesFlowManager: TrianglesFlowManager!
    
    init(_ mtkView: MTKView) {
        super.init()

        view = mtkView

        device = mtkView.device

        mtkView.preferredFramesPerSecond = 120
        mtkView.sampleCount = 4
        
        let library = device.makeDefaultLibrary()!
        pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = library.makeFunction(name: "main_vertex")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "main_fragment")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.sampleCount = 4

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        
        mtkView.clearColor = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        mtkView.isOpaque = false
        
        commandQueue = device.makeCommandQueue()!
        vertices = []
        trianglesFlowManager = TrianglesFlowManager()
        updateSize()
    }
    
    func touched(_ touches: Set<UITouch>, _ event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: nil)
            let vertex = Vertex(
                position: [Float(location.x), Float(location.y)],
                pointSize: 5 // Float(touch.force) * 20 + 8
            )
            trianglesFlowManager.addKeyVertex(vertex)
        }
        updateVertices()
    }
    
    func endTouch() {
        trianglesFlowManager.stop()
        updateVertices()
    }

    func draw(in view: MTKView) {
        let verticesCommandBuffer = commandQueue.makeCommandBuffer()!
        let verticesCommandEncoder = verticesCommandBuffer.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!)!

        if trianglesFlowManager.triangleVertices.count > 0 {
            verticesCommandEncoder.setRenderPipelineState(pipelineState)
            verticesCommandEncoder.setVertexBuffer(verticesInfosBuffer, offset: 0, index: 0)
            verticesCommandEncoder.setVertexBuffer(verticesBuffer, offset: 0, index: 1)
            // verticesCommandEncoder.setTriangleFillMode(.lines)
            verticesCommandEncoder.drawPrimitives(
                type: .triangle,
                vertexStart: 0,
                vertexCount: trianglesFlowManager.triangleVertices.count
            )
        }
        
        verticesCommandEncoder.endEncoding()
        verticesCommandBuffer.present(view.currentDrawable!)
        verticesCommandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        updateSize()
    }
    
    func updateVertices() {
        if trianglesFlowManager.triangleVertices.count > 0 {
            verticesBuffer = device.makeBuffer(
                bytes: trianglesFlowManager.triangleVertices,
                length: trianglesFlowManager.triangleVertices.count * MemoryLayout<Vertex>.stride,
                options: .storageModeShared
            )
        }
    }
    
    private func updateSize() {
        var verticesInfos = VertexInfos(width: Float(view.bounds.width), height: Float(view.bounds.height))
        verticesInfosBuffer = device.makeBuffer(
            bytes: &verticesInfos,
            length: MemoryLayout<VertexInfos>.size,
            options: .storageModeShared
        )
    }
}
