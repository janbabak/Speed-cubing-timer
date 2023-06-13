//
//  3DCubeView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 09.06.2023.
//

import SwiftUI
import SceneKit

// 3D Rubiks cube view
struct Puzzle3DVizualizationView: UIViewRepresentable {
    
    var puzzle: Puzzle = Cube3x3()
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        view.scene = puzzle.scene
        view.autoenablesDefaultLighting = true
        view.allowsCameraControl = true
        view.antialiasingMode = .multisampling2X
        view.backgroundColor = .clear
        view.pointOfView = puzzle.cameraNode
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct Puzzle3DVizualizationView_Previews: PreviewProvider {
    static var previews: some View {
        Puzzle3DVizualizationView()
    }
}
