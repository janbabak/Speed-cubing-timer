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
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        view.scene = cube.scene
        view.autoenablesDefaultLighting = true
        view.allowsCameraControl = true
        view.antialiasingMode = .multisampling2X
        view.backgroundColor = .clear
        
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
