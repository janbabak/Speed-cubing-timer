//
//  3DCubeView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 09.06.2023.
//

import SwiftUI
import SceneKit

struct Cube3DView: UIViewRepresentable {
    
    var cube = Cube()
    
    init() {
        
    }
    
    func makeUIView(context: Context) -> SCNView {
        let scene = SCNScene()

        let view = SCNView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
//        view.scene = scene
        view.scene = cube.scene
        view.backgroundColor = UIColor.lightGray
        view.autoenablesDefaultLighting = true
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.backgroundColor = .clear
//
//        let orangeCube = SCNNode()
//        orangeCube.geometry = SCNBox(width: 1, height: 1, length: 0.1, chamferRadius: 0.05)
//        orangeCube.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
//        orangeCube.geometry?.firstMaterial?.specular.contents = UIColor.white // refleciton color
//        orangeCube.position = SCNVector3(x: 0, y: 0, z: 0)
//
//        let blueCube = SCNNode()
//        blueCube.geometry = SCNBox(width: 0.1, height: 1, length: 1, chamferRadius: 0.05)
//        blueCube.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        blueCube.geometry?.firstMaterial?.specular.contents = UIColor.white
//        blueCube.position = SCNVector3(x: -0.5, y: 0, z: -0.5)
//
//        let greenCube = SCNNode()
//        greenCube.geometry = SCNBox(width: 1, height: 1, length: 0.1, chamferRadius: 0.05)
//        greenCube.geometry?.firstMaterial?.diffuse.contents = UIColor.green
//        greenCube.geometry?.firstMaterial?.specular.contents = UIColor.white
//        greenCube.position = SCNVector3(x: 1, y: 0, z: 0)
//
//        let redCube = SCNNode()
//        redCube.geometry = SCNBox(width: 1, height: 1, length: 0.1, chamferRadius: 0.05)
//        redCube.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//        redCube.geometry?.firstMaterial?.specular.contents = UIColor.white
//        redCube.position = SCNVector3(x: 2, y: 0, z: 0)
//
//        let yellowCube = SCNNode()
//        yellowCube.geometry = SCNBox(width: 1, height: 1, length: 0.1, chamferRadius: 0.05)
//        yellowCube.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
//        yellowCube.geometry?.firstMaterial?.specular.contents = UIColor.white
//        yellowCube.position = SCNVector3(x: 0, y: 0.5, z: -0.5)
//        yellowCube.runAction(SCNAction.rotateBy(x: -90.0 * Double.pi / 180.0, y: 0, z: 0, duration: 0.0))
//
//        scene.rootNode.addChildNode(orangeCube)
//        scene.rootNode.addChildNode(blueCube)
//        scene.rootNode.addChildNode(greenCube)
//        scene.rootNode.addChildNode(redCube)
//        scene.rootNode.addChildNode(yellowCube)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct Cube3DView_Previews: PreviewProvider {
    static var previews: some View {
//        Cube3DView()
        SettingsView()
    }
}
