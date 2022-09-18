//
//  CustomARView.swift
//  RealityKitMetal
//
//  Created by ミズキ on 2022/09/18.
//

import Foundation
import ARKit
import RealityKit
import MetalKit

class CustomARView: ARView {
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        environment.background = .color(.darkGray)
        
        let boxScene = try! Experience.loadBox()
        boxScene.children[0].scale *= 5.0
        
        let box = boxScene.steelBox!.children[0] as! ModelEntity
        
        guard let device = MTLCreateSystemDefaultDevice() else { return }
        guard let defaultLibrary = device.makeDefaultLibrary() else { return }
        let surfaceShader = CustomMaterial.SurfaceShader(named: "basicShader", in: defaultLibrary)
        let geometryModifier = CustomMaterial.GeometryModifier(named: "basicModifier", in: defaultLibrary)
        do {
            box.model?.materials[0] = try CustomMaterial(surfaceShader: surfaceShader,
                                                         geometryModifier: geometryModifier,
                                                         lightingModel: .lit)
        } catch {
            print("can't find custom Material")
        }
        
        scene.anchors.append(boxScene)
        
        // Rotation about Y axis
        
        box.components[PhysicsBodyComponent.self] = .init()
        box.components[PhysicsMotionComponent.self] = .init()
        box.physicsBody?.massProperties.mass = 0.0
        // 角速度
        box.physicsMotion?.angularVelocity.y = 1.0
        box.generateCollisionShapes(recursive: true)
    }
}
