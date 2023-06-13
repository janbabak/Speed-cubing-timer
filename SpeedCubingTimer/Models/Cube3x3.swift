//
//  Cube.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 09.06.2023.
//

import SceneKit

protocol Puzzle {
    var scene: SCNScene { get }
    var cameraNode: SCNNode { get }
    
    // scramble the cube
    func scramble(_ scramble: String)
}

class Cube3x3: Puzzle {
    private var tiles: [[[Block]]]
    private(set) var scene = SCNScene()
    private(set) var cameraNode = SCNNode()
    
    // MARK: - Cube constatnts
    static let rotation90deg = 90.0 * Float.pi / 180.0
    static let offset = Float(Tile.size / 2.0)
    static let xRotation = SCNVector3(x: Cube3x3.rotation90deg, y: 0, z: 0)
    static let yRotation = SCNVector3(x: 0, y: Cube3x3.rotation90deg, z: 0)
    static let noRotation = SCNVector3(x: 0, y: 0, z: 0)
    
    init() {
        self.tiles = Cube3x3.createCube(scene: self.scene)
        setUpCamera()
    }
    
    // MARK: - structs
    
    // center tile in each side of the cube (there are 6 centers)
    struct Center: Block {
        var tile: Tile
        
        init(tile: Tile, scene: SCNScene) {
            self.tile = tile
            
            addToScene(scene: scene)
        }
        
        func addToScene(scene: SCNScene) {
            scene.rootNode.addChildNode(tile.node)
        }
        
        // flush the color properties of tile to scene
        func flushColor() {
            tile.flushColor()
        }
    }
    
    // edge of the cube (there are 12 edges)
    struct Edge: Block {
        var xTile: Tile
        var yTile: Tile
        
        init(xTile: Tile, yTile: Tile, scene: SCNScene) {
            self.xTile = xTile
            self.yTile = yTile
            
            addToScene(scene: scene)
        }
        
        func addToScene(scene: SCNScene) {
            scene.rootNode.addChildNode(xTile.node)
            scene.rootNode.addChildNode(yTile.node)
        }
        
        // flush the color properties of tiles to scene
        func flushColor() {
            xTile.flushColor()
            yTile.flushColor()
        }
    }
    
    // corner of the cube (there are 8 corners)
    struct Corner: Block {
        var xTile: Tile
        var yTile: Tile
        var zTile: Tile
        
        init(xTile: Tile, yTile: Tile, zTile: Tile, scene: SCNScene) {
            self.xTile = xTile
            self.yTile = yTile
            self.zTile = zTile
            
            addToScene(scene: scene)
        }
        
        func addToScene(scene: SCNScene) {
            scene.rootNode.addChildNode(xTile.node)
            scene.rootNode.addChildNode(yTile.node)
            scene.rootNode.addChildNode(zTile.node)
        }
        
        // flush the color properties of tiles to scene
        func flushColor() {
            xTile.flushColor()
            yTile.flushColor()
            zTile.flushColor()
        }
    }
    
    // middle piece of the cube - core (there is only 1 core) not rendered
    struct Core: Block {
        func flushColor() {
            return
        }
        
        func addToScene(scene: SCNScene) {
            return
        }
    }
    
    // Tile is on squeare of color
    struct Tile {
        var node = SCNNode()
        var color: UIColor
        
        static let size: CGFloat = 1.0
        static let length: CGFloat = size / 7.5
        static let chamferRadius = 0.1
        
        init(color: UIColor, position: SCNVector3, rotation: SCNVector3) {
            node.geometry = SCNBox(width: Tile.size, height: Tile.size, length: Tile.length, chamferRadius: Tile.chamferRadius)
            node.geometry?.firstMaterial?.diffuse.contents = color
            node.geometry?.firstMaterial?.specular.contents = UIColor.white
            node.position = position
            node.runAction(
                SCNAction.rotateBy(
                    x: CGFloat(rotation.x),
                    y: CGFloat(rotation.y),
                    z: CGFloat(rotation.z),
                    duration: 0.0
                )
            )
            self.color = color
        }
        
        // flush the color property to scene
        func flushColor() {
            node.geometry?.firstMaterial?.diffuse.contents = color
        }
    }
    
    // MARK: - public methods
    
    // scramble the cube
    func scramble(_ scramble: String) {
        resetToSolvedState() // scrambling always starts from solve state
        
        let moves = scramble.components(separatedBy: " ")
        
        for move in moves {
            switch move {
                
                //right cube face
            case "R":
                turnR()
            case "R2":
                turnR2()
            case "R\'":
                turnRPrime()
                
                //left cube face
            case "L":
                turnL()
            case "L2":
                turnL2()
            case "L\'":
                turnLPrime()
                
                //front cube face
            case "F":
                turnF()
            case "F2":
                turnF2()
            case "F\'":
                turnFPrime()
                
                //back cube face
            case "B":
                turnB()
            case "B2":
                turnB2()
            case "B\'":
                turnBPrime()
                
                //upper cube face
            case "U":
                turnU()
            case "U2":
                turnU2()
            case "U\'":
                turnUPrime()
                
                //down cube face
            case "D":
                turnD()
            case "D2":
                turnD2()
            case "D\'":
                turnDPrime()
                
            default:
                print("move not found")
            }
        }

        flushColor()
    }
    
    // MARK: - private methods
    
    // make the L (left) move
    private func turnL() {
        // corners
        var corner1 = tiles[0][0][0] as! Corner // orange, white, green
        var corner2 = tiles[0][0][2] as! Corner // orange, white, blue
        var corner3 = tiles[2][0][2] as! Corner // orange, yellow, blue
        var corner4 = tiles[2][0][0] as! Corner // orange, yellow, green
        
        let corner1xTileColor = corner1.xTile.color
        let corner1yTileColor = corner1.yTile.color
        let corner1zTileColor = corner1.zTile.color
        
        corner1.xTile.color = corner2.yTile.color
        corner1.yTile.color = corner2.xTile.color
        corner1.zTile.color = corner2.zTile.color
        
        corner2.xTile.color = corner3.yTile.color
        corner2.yTile.color = corner3.xTile.color
        corner2.zTile.color = corner3.zTile.color
        
        corner3.xTile.color = corner4.yTile.color
        corner3.yTile.color = corner4.xTile.color
        corner3.zTile.color = corner4.zTile.color
        
        corner4.xTile.color = corner1yTileColor
        corner4.yTile.color = corner1xTileColor
        corner4.zTile.color = corner1zTileColor
        
        tiles[0][0][0] = corner1
        tiles[0][0][2] = corner2
        tiles[2][0][2] = corner3
        tiles[2][0][0] = corner4
        
        // edges
        var edge1 = tiles[0][0][1] as! Edge // orange, white
        var edge2 = tiles[1][0][2] as! Edge // orange, blue
        var edge3 = tiles[2][0][1] as! Edge // orange, yellow
        var edge4 = tiles[1][0][0] as! Edge // orange, green
        
        let edge1xTileColor = edge1.xTile.color
        let edge1yTileColor = edge1.yTile.color
        
        edge1.xTile.color = edge2.yTile.color
        edge1.yTile.color = edge2.xTile.color
        
        edge2.yTile.color = edge3.xTile.color
        edge2.xTile.color = edge3.yTile.color
        
        edge3.xTile.color = edge4.yTile.color
        edge3.yTile.color = edge4.xTile.color
        
        edge4.yTile.color = edge1xTileColor
        edge4.xTile.color = edge1yTileColor
        
        tiles[0][0][1] = edge1
        tiles[1][0][2] = edge2
        tiles[2][0][1] = edge3
        tiles[1][0][0] = edge4
    }
    
    // make L' (left counter-clockwise) move
    private func turnLPrime() {
        turnL()
        turnL()
        turnL()
    }
    
    // make L2 (left by twice) move
    private func turnL2() {
        turnL()
        turnL()
    }
    
    // make the R (right) move
    private func turnR() {
        // corners
        var corner1 = tiles[0][2][0] as! Corner // red, white, green
        var corner2 = tiles[0][2][2] as! Corner // red, white, blue
        var corner3 = tiles[2][2][2] as! Corner // red, yellow, blue
        var corner4 = tiles[2][2][0] as! Corner // red, yellow, green
        
        let corner4xTileColor = corner4.xTile.color
        let corner4yTileColor = corner4.yTile.color
        let corner4zTileColor = corner4.zTile.color
        
        corner4.xTile.color = corner3.yTile.color
        corner4.yTile.color = corner3.xTile.color
        corner4.zTile.color = corner3.zTile.color
        
        corner3.xTile.color = corner2.yTile.color
        corner3.yTile.color = corner2.xTile.color
        corner3.zTile.color = corner2.zTile.color
        
        corner2.xTile.color = corner1.yTile.color
        corner2.yTile.color = corner1.xTile.color
        corner2.zTile.color = corner1.zTile.color
        
        corner1.xTile.color = corner4yTileColor
        corner1.yTile.color = corner4xTileColor
        corner1.zTile.color = corner4zTileColor
        
        tiles[0][2][0] = corner1
        tiles[0][2][2] = corner2
        tiles[2][2][2] = corner3
        tiles[2][2][0] = corner4
        
        // edges
        var edge1 = tiles[0][2][1] as! Edge // red, white
        var edge2 = tiles[1][2][2] as! Edge // red, blue
        var edge3 = tiles[2][2][1] as! Edge // red, yellow
        var edge4 = tiles[1][2][0] as! Edge // red, green
        
        let edge4yTileColor = edge4.yTile.color
        let edge4xTileColor = edge4.xTile.color
        
        edge4.yTile.color = edge3.xTile.color
        edge4.xTile.color = edge3.yTile.color
        
        edge3.xTile.color = edge2.yTile.color
        edge3.yTile.color = edge2.xTile.color
        
        edge2.yTile.color = edge1.xTile.color
        edge2.xTile.color = edge1.yTile.color
        
        edge1.xTile.color = edge4yTileColor
        edge1.yTile.color = edge4xTileColor
        
        tiles[0][2][1] = edge1
        tiles[1][2][2] = edge2
        tiles[2][2][1] = edge3
        tiles[1][2][0] = edge4
    }
    
    // make R' (right counter-clockwise) move
    private func turnRPrime() {
        turnR()
        turnR()
        turnR()
    }
    
    // make R2 (right by twice) move
    private func turnR2() {
        turnR()
        turnR()
    }
    
    // make the F (front) move
    private func turnF() {
        // corners
        var corner1 = tiles[0][0][0] as! Corner // green, white, orange
        var corner2 = tiles[0][2][0] as! Corner // green, white, red
        var corner3 = tiles[2][2][0] as! Corner // green, yellow, red
        var corner4 = tiles[2][0][0] as! Corner // green, yellow, orange
        
        let corner4xTileColor = corner4.xTile.color
        let corner4zTileColor = corner4.zTile.color
        let corner4yTileColor = corner4.yTile.color
        
        corner4.xTile.color = corner3.zTile.color
        corner4.zTile.color = corner3.xTile.color
        corner4.yTile.color = corner3.yTile.color
        
        corner3.xTile.color = corner2.zTile.color
        corner3.zTile.color = corner2.xTile.color
        corner3.yTile.color = corner2.yTile.color
        
        corner2.xTile.color = corner1.zTile.color
        corner2.zTile.color = corner1.xTile.color
        corner2.yTile.color = corner1.yTile.color
        
        corner1.xTile.color = corner4zTileColor
        corner1.zTile.color = corner4xTileColor
        corner1.yTile.color = corner4yTileColor
        
        tiles[0][0][0] = corner1
        tiles[0][2][0] = corner2
        tiles[2][2][0] = corner3
        tiles[2][0][0] = corner4
        
        // edges
        var edge1 = tiles[0][1][0] as! Edge // green, white
        var edge2 = tiles[1][2][0] as! Edge // green, red
        var edge3 = tiles[2][1][0] as! Edge // green, yellow
        var edge4 = tiles[1][0][0] as! Edge // green, orange
        
        let edge4xTileColor = edge4.xTile.color
        let edge4yTileColor = edge4.yTile.color
        
        edge4.xTile.color = edge3.xTile.color
        edge4.yTile.color = edge3.yTile.color
        
        edge3.xTile.color = edge2.xTile.color
        edge3.yTile.color = edge2.yTile.color
        
        edge2.xTile.color = edge1.xTile.color
        edge2.yTile.color = edge1.yTile.color
        
        edge1.xTile.color = edge4xTileColor
        edge1.yTile.color = edge4yTileColor
        
        tiles[0][1][0] = edge1
        tiles[1][2][0] = edge2
        tiles[2][1][0] = edge3
        tiles[1][0][0] = edge4
    }
    
    // make F' (front counter-clockwise) move
    private func turnFPrime() {
        turnF()
        turnF()
        turnF()
    }
    
    // make F2 (front by twice) move
    private func turnF2() {
        turnF()
        turnF()
    }
    
    // make the B (back) move
    private func turnB() {
        // corners
        var corner1 = tiles[0][0][2] as! Corner // blue, white, orange
        var corner2 = tiles[0][2][2] as! Corner // blue, white, red
        var corner3 = tiles[2][2][2] as! Corner // blue, yellow, red
        var corner4 = tiles[2][0][2] as! Corner // blue, yellow, orange
        
        let corner1xTileColor = corner1.xTile.color
        let corner1zTileColor = corner1.zTile.color
        let corner1yTileColor = corner1.yTile.color
        
        corner1.xTile.color = corner2.zTile.color
        corner1.zTile.color = corner2.xTile.color
        corner1.yTile.color = corner2.yTile.color
        
        corner2.xTile.color = corner3.zTile.color
        corner2.zTile.color = corner3.xTile.color
        corner2.yTile.color = corner3.yTile.color
        
        corner3.xTile.color = corner4.zTile.color
        corner3.zTile.color = corner4.xTile.color
        corner3.yTile.color = corner4.yTile.color
        
        corner4.xTile.color = corner1zTileColor
        corner4.zTile.color = corner1xTileColor
        corner4.yTile.color = corner1yTileColor
        
        tiles[0][0][2] = corner1
        tiles[0][2][2] = corner2
        tiles[2][2][2] = corner3
        tiles[2][0][2] = corner4
        
        // edges
        var edge1 = tiles[0][1][2] as! Edge // blue, white
        var edge2 = tiles[1][2][2] as! Edge // blue, red
        var edge3 = tiles[2][1][2] as! Edge // blue, yellow
        var edge4 = tiles[1][0][2] as! Edge // blue, orange
        
        let edge1xTileColor = edge1.xTile.color
        let edge1yTileColor = edge1.yTile.color
        
        edge1.xTile.color = edge2.xTile.color
        edge1.yTile.color = edge2.yTile.color
        
        edge2.xTile.color = edge3.xTile.color
        edge2.yTile.color = edge3.yTile.color
        
        edge3.xTile.color = edge4.xTile.color
        edge3.yTile.color = edge4.yTile.color
        
        edge4.xTile.color = edge1xTileColor
        edge4.yTile.color = edge1yTileColor
        
        tiles[0][1][2] = edge1
        tiles[1][2][2] = edge2
        tiles[2][1][2] = edge3
        tiles[1][0][2] = edge4
    }
    
    // make B' (back counter-clockwise) move
    private func turnBPrime() {
        turnB()
        turnB()
        turnB()
    }
    
    // make B2 (back by twice) move
    private func turnB2() {
        turnB()
        turnB()
    }
    
    // make the U (up) move
    private func turnU() {
        // corners
        var corner1 = tiles[0][2][0] as! Corner // white, red, green
        var corner2 = tiles[0][0][0] as! Corner // white, orange, green
        var corner3 = tiles[0][0][2] as! Corner // white, orange, blue
        var corner4 = tiles[0][2][2] as! Corner // white, red, blue
        
        let corner4zTileColor = corner4.zTile.color
        let corner4yTileColor = corner4.yTile.color
        let corner4xTileColor = corner4.xTile.color
        
        corner4.zTile.color = corner3.yTile.color
        corner4.yTile.color = corner3.zTile.color
        corner4.xTile.color = corner3.xTile.color
        
        corner3.zTile.color = corner2.yTile.color
        corner3.yTile.color = corner2.zTile.color
        corner3.xTile.color = corner2.xTile.color
        
        corner2.zTile.color = corner1.yTile.color
        corner2.yTile.color = corner1.zTile.color
        corner2.xTile.color = corner1.xTile.color
        
        corner1.zTile.color = corner4yTileColor
        corner1.yTile.color = corner4zTileColor
        corner1.xTile.color = corner4xTileColor
        
        tiles[0][2][0] = corner1
        tiles[0][0][0] = corner2
        tiles[0][0][2] = corner3
        tiles[0][2][2] = corner4
        
        // edges
        var edge1 = tiles[0][1][0] as! Edge // white, green
        var edge2 = tiles[0][0][1] as! Edge // white, orange
        var edge3 = tiles[0][1][2] as! Edge // white, blue
        var edge4 = tiles[0][2][1] as! Edge // white, red
        
        let edge4yTileColor = edge4.yTile.color
        let edge4xTileColor = edge4.xTile.color
        
        edge4.yTile.color = edge3.yTile.color
        edge4.xTile.color = edge3.xTile.color
        
        edge3.yTile.color = edge2.yTile.color
        edge3.xTile.color = edge2.xTile.color
        
        edge2.yTile.color = edge1.yTile.color
        edge2.xTile.color = edge1.xTile.color
        
        edge1.yTile.color = edge4yTileColor
        edge1.xTile.color = edge4xTileColor
        
        tiles[0][1][0] = edge1
        tiles[0][0][1] = edge2
        tiles[0][1][2] = edge3
        tiles[0][2][1] = edge4
    }
    
    // make U' (up counter-clockwise) move
    private func turnUPrime() {
        turnU()
        turnU()
        turnU()
    }
    
    // make U2 (up by twice) move
    private func turnU2() {
        turnU()
        turnU()
    }
    
    // make the D (down) move
    private func turnD() {
        // corners
        var corner1 = tiles[2][2][0] as! Corner // yellow, red, green
        var corner2 = tiles[2][0][0] as! Corner // yellow, orange, green
        var corner3 = tiles[2][0][2] as! Corner // yellow, orange, blue
        var corner4 = tiles[2][2][2] as! Corner // yellow, red, blue
        
        let corner1zTileColor = corner1.zTile.color
        let corner1yTileColor = corner1.yTile.color
        let corner1xTileColor = corner1.xTile.color
        
        corner1.zTile.color = corner2.yTile.color
        corner1.yTile.color = corner2.zTile.color
        corner1.xTile.color = corner2.xTile.color
        
        corner2.zTile.color = corner3.yTile.color
        corner2.yTile.color = corner3.zTile.color
        corner2.xTile.color = corner3.xTile.color
        
        corner3.zTile.color = corner4.yTile.color
        corner3.yTile.color = corner4.zTile.color
        corner3.xTile.color = corner4.xTile.color
        
        corner4.zTile.color = corner1yTileColor
        corner4.yTile.color = corner1zTileColor
        corner4.xTile.color = corner1xTileColor
        
        tiles[2][2][0] = corner1
        tiles[2][0][0] = corner2
        tiles[2][0][2] = corner3
        tiles[2][2][2] = corner4
        
        // edges
        var edge1 = tiles[2][1][0] as! Edge // yellow, green
        var edge2 = tiles[2][0][1] as! Edge // yellow, orange
        var edge3 = tiles[2][1][2] as! Edge // yellow, blue
        var edge4 = tiles[2][2][1] as! Edge // yellow, red
        
        let edge1yTileColor = edge1.yTile.color
        let edge1xTileColor = edge1.xTile.color
        
        edge1.yTile.color = edge2.yTile.color
        edge1.xTile.color = edge2.xTile.color
        
        edge2.yTile.color = edge3.yTile.color
        edge2.xTile.color = edge3.xTile.color
        
        edge3.yTile.color = edge4.yTile.color
        edge3.xTile.color = edge4.xTile.color
        
        edge4.yTile.color = edge1yTileColor
        edge4.xTile.color = edge1xTileColor
        
        tiles[2][1][0] = edge1
        tiles[2][0][1] = edge2
        tiles[2][1][2] = edge3
        tiles[2][2][1] = edge4
    }
    
    // make D' (down counter-clockwise) move
    private func turnDPrime() {
        turnD()
        turnD()
        turnD()
    }
    
    // make D2 (down by twice) move
    private func turnD2() {
        turnD()
        turnD()
    }
    
    // flush the colors of blocks of tiles to scene
    private func flushColor() {
        for i in 0..<3 {
            for j in 0..<3 {
                for k in 0..<3 {
                    tiles[i][j][k].flushColor()
                }
            }
        }
    }
    
    // reset colors to solved state
    private func resetToSolvedState(flushColors: Bool = false) {
        // corners
        
        // white, green, orange
        var corner1 = tiles[0][0][0] as! Corner
        corner1.xTile.color = .white
        corner1.yTile.color = .green
        corner1.zTile.color = .orange
        tiles[0][0][0] = corner1
        
        // white, blue, orange
        corner1 = tiles[0][0][2] as! Corner
        corner1.xTile.color = .white
        corner1.yTile.color = .blue
        corner1.zTile.color = .orange
        tiles[0][0][2] = corner1
        
        // white, blue, red
        corner1 = tiles[0][2][2] as! Corner
        corner1.xTile.color = .white
        corner1.yTile.color = .blue
        corner1.zTile.color = .red
        tiles[0][2][2] = corner1
        
        // white, green, orange
        corner1 = tiles[0][2][0] as! Corner
        corner1.xTile.color = .white
        corner1.yTile.color = .green
        corner1.zTile.color = .red
        tiles[0][2][0] = corner1
        
        // yellow, green, orange
        corner1 = tiles[2][0][0] as! Corner
        corner1.xTile.color = .yellow
        corner1.yTile.color = .green
        corner1.zTile.color = .orange
        tiles[2][0][0] = corner1
        
        // yellow, blue, orange
        corner1 = tiles[2][0][2] as! Corner
        corner1.xTile.color = .yellow
        corner1.yTile.color = .blue
        corner1.zTile.color = .orange
        tiles[2][0][2] = corner1
        
        // yellow, blue, red
        corner1 = tiles[2][2][2] as! Corner
        corner1.xTile.color = .yellow
        corner1.yTile.color = .blue
        corner1.zTile.color = .red
        tiles[2][2][2] = corner1
        
        // yellow, green, orange
        corner1 = tiles[2][2][0] as! Corner
        corner1.xTile.color = .yellow
        corner1.yTile.color = .green
        corner1.zTile.color = .red
        tiles[2][2][0] = corner1
        
        // edges
        
        // white, green
        var edge = tiles[0][1][0] as! Edge
        edge.xTile.color = .white
        edge.yTile.color = .green
        tiles[0][1][0] = edge
        
        // white, orange
        edge = tiles[0][0][1] as! Edge
        edge.xTile.color = .white
        edge.yTile.color = .orange
        tiles[0][0][1] = edge
        
        // white, blue
        edge = tiles[0][1][2] as! Edge
        edge.xTile.color = .white
        edge.yTile.color = .blue
        tiles[0][1][2] = edge
        
        // white, red
        edge = tiles[0][2][1] as! Edge
        edge.xTile.color = .white
        edge.yTile.color = .red
        tiles[0][2][1] = edge
        
        // green, orange
        edge = tiles[1][0][0] as! Edge
        edge.xTile.color = .orange
        edge.yTile.color = .green
        tiles[1][0][0] = edge
        
        // blue, orange
        edge = tiles[1][0][2] as! Edge
        edge.xTile.color = .orange
        edge.yTile.color = .blue
        tiles[1][0][2] = edge
        
        // blue, red
        edge = tiles[1][2][2] as! Edge
        edge.xTile.color = .red
        edge.yTile.color = .blue
        tiles[1][2][2] = edge
        
        // green, red
        edge = tiles[1][2][0] as! Edge
        edge.xTile.color = .red
        edge.yTile.color = .green
        tiles[1][2][0] = edge
        
        // yellow, green
        edge = tiles[2][1][0] as! Edge
        edge.xTile.color = .yellow
        edge.yTile.color = .green
        tiles[2][1][0] = edge
        
        // yellow, orange
        edge = tiles[2][0][1] as! Edge
        edge.xTile.color = .yellow
        edge.yTile.color = .orange
        tiles[2][0][1] = edge
        
        // yellow, blue
        edge = tiles[2][1][2] as! Edge
        edge.xTile.color = .yellow
        edge.yTile.color = .blue
        tiles[2][1][2] = edge
        
        // yellow, red
        edge = tiles[2][2][1] as! Edge
        edge.xTile.color = .yellow
        edge.yTile.color = .red
        tiles[2][2][1] = edge
        
        if flushColors {
            flushColor()
        }
    }
    
    // look at the cube from 35 and 45 degree X and Y axis angles
    private func setUpCamera() {
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: -3.5, y: 2.0, z: 2) // -3.5 3.5 2
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.eulerAngles = SCNVector3(
            x: -35.0 * Float.pi / 180.0, //45
            y: -45.0 * Float.pi / 180.0,
            z: 0
        )
    }
    
    // initialize the tile property by empty arrays
    private static func initTiles() -> [[[Block]]] {
        var tilesLocal: [[[Block]]] = []
        for _ in 0..<3 {
            var tmp: [[Block]] = []
            for _ in 0..<3 {
                tmp.append([])
            }
            tilesLocal.append(tmp)
        }
        return tilesLocal
    }
    
    // create tiles
    private static func createCube(scene: SCNScene) -> [[[Block]]] {
        var tiles = Cube3x3.initTiles()
        
        // MARK: - first layer
        
        // white, green, orange corner
        tiles[0][0].append(
            Corner(
                xTile:
                    Tile(
                        color: .white,
                        position: SCNVector3(x: -2 * Cube3x3.offset, y: Cube3x3.offset, z: -Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: -2 * Cube3x3.offset, y: 0, z: 0),
                        rotation: Cube3x3.noRotation
                    ),
                zTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube3x3.offset, y: 0, z: -Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // white orange edge
        tiles[0][0].append(
            Edge(
                xTile:
                    Tile(
                        color: .white,
                        position: SCNVector3(x: -2 * Cube3x3.offset, y: Cube3x3.offset, z: -3 * Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube3x3.offset, y: 0, z: -3 * Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // white orange blue corner
        tiles[0][0].append(
            Corner(
                xTile:
                    Tile(
                        color: .white,
                        position: SCNVector3(x: -2 * Cube3x3.offset, y: Cube3x3.offset, z: -5 * Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: -2 * Cube3x3.offset, y: 0, z: -6 * Cube3x3.offset),
                        rotation: Cube3x3.noRotation
                    ),
                zTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube3x3.offset, y: 0, z: -5 * Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // white green edge
        tiles[0][1].append(
            Edge(
                xTile:
                    Tile(
                        color: .white,
                        position: SCNVector3(x: 0, y: Cube3x3.offset, z: -Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 0, y: 0, z: 0),
                        rotation: Cube3x3.noRotation
                    ),
                scene: scene
            )
        )
        
        // white center
        tiles[0][1].append(
            Center(
                tile:
                    Tile(
                        color: .white,
                        position: SCNVector3(x: 0, y: Cube3x3.offset, z: -3 * Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                scene: scene
            )
        )
        
        // white blue edge
        tiles[0][1].append(
            Edge(
                xTile:
                    Tile(
                        color: .white,
                        position: SCNVector3(x: 0, y: Cube3x3.offset, z: -5 * Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 0, y: 0, z: -6 * Cube3x3.offset),
                        rotation: Cube3x3.noRotation
                    ),
                scene: scene
            )
        )
        
        // white, green, red corner
        tiles[0][2].append(
            Corner(
                xTile:
                    Tile(
                        color: .white,
                        position: SCNVector3(x: 2 * Cube3x3.offset, y: Cube3x3.offset, z: -Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 2 * Cube3x3.offset, y: 0, z: 0),
                        rotation: Cube3x3.noRotation
                    ),
                zTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube3x3.offset, y: 0, z: -Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // white red edge
        tiles[0][2].append(
            Edge(
                xTile:
                    Tile(
                        color: .white,
                        position: SCNVector3(x: 2 * Cube3x3.offset, y: Cube3x3.offset, z: -3 * Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube3x3.offset, y: 0, z: -3 * Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // white, blue, red corner
        tiles[0][2].append(
            Corner(
                xTile:
                    Tile(
                        color: .white,
                        position: SCNVector3(x: 2 * Cube3x3.offset, y: Cube3x3.offset, z: -5 * Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 2 * Cube3x3.offset, y: 0, z: -6 * Cube3x3.offset),
                        rotation: Cube3x3.noRotation
                    ),
                zTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube3x3.offset, y: 0, z: -5 * Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // MARK: - second layer
        
        // orange green
        tiles[1][0].append(
            Edge(
                xTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube3x3.offset, y: -2 * Cube3x3.offset, z: -Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: -2 * Cube3x3.offset, y: -2 * Cube3x3.offset, z: 0),
                        rotation: Cube3x3.noRotation
                    ),
                scene: scene
            )
        )
        
        // orange center
        tiles[1][0].append(
            Center(
                tile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube3x3.offset, y: -2 * Cube3x3.offset, z: -3 * Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // orange blue
        tiles[1][0].append(
            Edge(
                xTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube3x3.offset, y: -2 * Cube3x3.offset, z: -5 * Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: -2 * Cube3x3.offset, y: -2 * Cube3x3.offset, z: -6 * Cube3x3.offset),
                        rotation: Cube3x3.noRotation
                    ),
                scene: scene
            )
        )
        
        // green center
        tiles[1][1].append(
            Center(
                tile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 0, y: -2 * Cube3x3.offset, z: 0),
                        rotation: Cube3x3.noRotation
                    ),
                scene: scene
            )
        )
        
        // middle core (just because I don't want to leave it's place empty (for better array manipulations)
        tiles[1][1].append(
            Core()
        )
        
        // blue center
        tiles[1][1].append(
            Center(
                tile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 0, y: -2 * Cube3x3.offset, z: -6 * Cube3x3.offset),
                        rotation: Cube3x3.noRotation
                    ),
                scene: scene
            )
        )
        
        // red green
        tiles[1][2].append(
            Edge(
                xTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube3x3.offset, y: -2 * Cube3x3.offset, z: -Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 2 * Cube3x3.offset, y: -2 * Cube3x3.offset, z: 0),
                        rotation: Cube3x3.noRotation
                    ),
                scene: scene
            )
        )
        
        // red center
        tiles[1][2].append(
            Center(
                tile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube3x3.offset, y: -2 * Cube3x3.offset, z: -3 * Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // red blue
        tiles[1][2].append(
            Edge(
                xTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube3x3.offset, y: -2 * Cube3x3.offset, z: -5 * Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 2 * Cube3x3.offset, y: -2 * Cube3x3.offset, z: -6 * Cube3x3.offset),
                        rotation: Cube3x3.noRotation
                    ),
                scene: scene
            )
        )
        
        // MARK: - third layer
        
        // yellow, green, orange corner
        tiles[2][0].append(
            Corner(
                xTile:
                    Tile(
                        color: .yellow,
                        position: SCNVector3(x: -2 * Cube3x3.offset, y: -5 * Cube3x3.offset, z: -Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: -2 * Cube3x3.offset, y: -4 * Cube3x3.offset, z: 0),
                        rotation: Cube3x3.noRotation
                    ),
                zTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube3x3.offset, y: -4 * Cube3x3.offset, z: -Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // yellow orange edge
        tiles[2][0].append(
            Edge(
                xTile:
                    Tile(
                        color: .yellow,
                        position: SCNVector3(x: -2 * Cube3x3.offset, y: -5 * Cube3x3.offset, z: -3 * Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube3x3.offset, y: -4 * Cube3x3.offset, z: -3 * Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // yellow orange blue corner
        tiles[2][0].append(
            Corner(
                xTile:
                    Tile(
                        color: .yellow,
                        position: SCNVector3(x: -2 * Cube3x3.offset, y: -5 * Cube3x3.offset, z: -5 * Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: -2 * Cube3x3.offset, y: -4 * Cube3x3.offset, z: -6 * Cube3x3.offset),
                        rotation: Cube3x3.noRotation
                    ),
                zTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube3x3.offset, y: -4 * Cube3x3.offset, z: -5 * Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // yellow green edge
        tiles[2][1].append(
            Edge(
                xTile:
                    Tile(
                        color: .yellow,
                        position: SCNVector3(x: 0, y: -5 * Cube3x3.offset, z: -Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 0, y: -4 * Cube3x3.offset, z: 0),
                        rotation: Cube3x3.noRotation
                    ),
                scene: scene
            )
        )
        
        // yellow center
        tiles[2][1].append(
            Center(
                tile:
                    Tile(
                        color: .yellow,
                        position: SCNVector3(x: 0, y: -5 * Cube3x3.offset, z: -3 * Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                scene: scene
            )
        )
        
        // yellow blue edge
        tiles[2][1].append(
            Edge(
                xTile:
                    Tile(
                        color: .yellow,
                        position: SCNVector3(x: 0, y: -5 * Cube3x3.offset, z: -5 * Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 0, y: -4 * Cube3x3.offset, z: -6 * Cube3x3.offset),
                        rotation: Cube3x3.noRotation
                    ),
                scene: scene
            )
        )
        
        // yellow, green, red corner
        tiles[2][2].append(
            Corner(
                xTile:
                    Tile(
                        color: .yellow,
                        position: SCNVector3(x: 2 * Cube3x3.offset, y: -5 * Cube3x3.offset, z: -Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 2 * Cube3x3.offset, y: -4 * Cube3x3.offset, z: 0),
                        rotation: Cube3x3.noRotation
                    ),
                zTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube3x3.offset, y: -4 * Cube3x3.offset, z: -Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // yellow red edge
        tiles[2][2].append(
            Edge(
                xTile:
                    Tile(
                        color: .yellow,
                        position: SCNVector3(x: 2 * Cube3x3.offset, y: -5 * Cube3x3.offset, z: -3 * Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube3x3.offset, y: -4 * Cube3x3.offset, z: -3 * Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        // yellow, blue, red corner
        tiles[2][2].append(
            Corner(
                xTile:
                    Tile(
                        color: .yellow,
                        position: SCNVector3(x: 2 * Cube3x3.offset, y: -5 * Cube3x3.offset, z: -5 * Cube3x3.offset),
                        rotation: Cube3x3.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 2 * Cube3x3.offset, y: -4 * Cube3x3.offset, z: -6 * Cube3x3.offset),
                        rotation: Cube3x3.noRotation
                    ),
                zTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube3x3.offset, y: -4 * Cube3x3.offset, z: -5 * Cube3x3.offset),
                        rotation: Cube3x3.yRotation
                    ),
                scene: scene
            )
        )
        
        return tiles
    }
}

// block can be ether Corner or Edge or Center or Core
protocol Block {
    // add block the the scene
    func addToScene(scene: SCNScene)
    
    // flush colors from tiles properties to the scene
    func flushColor()
}
