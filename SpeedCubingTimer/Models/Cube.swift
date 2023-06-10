//
//  Cube.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 09.06.2023.
//

import SceneKit

class Cube {
    var tiles: [[[Block]]]
    var scene = SCNScene()
    
    // MARK: - Cube constatnts
    static let rotation90deg = 90.0 * Float.pi / 180.0
    static let offset = Float(Tile.size / 2.0)
    static let xRotation = SCNVector3(x: Cube.rotation90deg, y: 0, z: 0)
    static let yRotation = SCNVector3(x: 0, y: Cube.rotation90deg, z: 0)
    static let noRotation = SCNVector3(x: 0, y: 0, z: 0)
    
    // MARK: - structs
    
    // center tile in each side of the cube (there are 6 centers)
    struct Center: Block {
        func updateColor() {
            
        }
        
        var tile: Tile

        init(tile: Tile, scene: SCNScene) {
            self.tile = tile
            
            addToScene(scene: scene)
        }
        
        func addToScene(scene: SCNScene) {
            scene.rootNode.addChildNode(tile.node)
        }
        
        func rotate(by worldRotation: SCNVector4, aroundTarget worldTarget: SCNVector3) {
            tile.node.rotate(by: worldRotation, aroundTarget: worldTarget)
            
//            let action = SCNAction.rotate(
//                by: 90 * CGFloat(Double.pi / 180.0),
//                around: .init(x: 2, y: -2 * Cube.offset, z: 0),
//                duration: 2
//            )
//            tile.node.runAction(action)
//            let rotateAction = SCNAction.repeatForever(
//                SCNAction.rotate(by: .pi * 2, around: SCNVector3(0, 1, 0), duration: rotationDuration)
//            )
//            centerNode.runAction(rotateAction)
        }
    }
    
    // edge of the cube (there are 12 edges)
    struct Edge: Block {
        func rotate(by worldRotation: SCNVector4, aroundTarget worldTarget: SCNVector3) {
            
        }
        
        
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
        
        func updateColor() {
            xTile.updateColor()
            yTile.updateColor()
        }
    }
    
    // corner of the cube (there are 8 corners)
    struct Corner: Block {
        func rotate(by worldRotation: SCNVector4, aroundTarget worldTarget: SCNVector3) {
            
        }
        
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
        
        func updateColor() {
            xTile.updateColor()
            yTile.updateColor()
            zTile.updateColor()
        }
    }
    
    // middle piece of the cube - core (there is only 1 core) not rendered
    struct Core: Block {
        func updateColor() {
            
        }
        
        func rotate(by worldRotation: SCNVector4, aroundTarget worldTarget: SCNVector3) {
            
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
        static let length: CGFloat = size / 10.0
        static let chamferRadius = 0.05

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
        
        func updateColor() {
            node.geometry?.firstMaterial?.diffuse.contents = color
        }
    }
    
    func scramble() {
        
    }
    
    // makes the L move
    func turnL() {
        // corners
        var corner1 = tiles[0][0][0] as! Corner // white, green, orange
        var corner2 = tiles[0][0][2] as! Corner // white, blue, orange
        var corner3 = tiles[2][0][2] as! Corner // yellow, blue, orange
        var corner4 = tiles[2][0][0] as! Corner // yellow, green, orange
        
        let corner1xTileColor = corner1.xTile.color
        let corner1yTileColor = corner1.yTile.color
        
        corner1.xTile.color = corner2.yTile.color
        corner1.yTile.color = corner2.xTile.color
        
        corner2.xTile.color = corner3.yTile.color
        corner2.yTile.color = corner3.xTile.color
        
        corner3.xTile.color = corner4.yTile.color
        corner3.yTile.color = corner4.xTile.color
        
        corner4.xTile.color = corner1yTileColor
        corner4.yTile.color = corner1xTileColor
        
        tiles[0][0][0] = corner1
        tiles[0][0][2] = corner2
        tiles[2][0][2] = corner3
        tiles[2][0][0] = corner4
        
        // edges
        var edge1 = tiles[0][0][1] as! Edge // white, orange
        var edge2 = tiles[1][0][2] as! Edge // blue, orange
        var edge3 = tiles[2][0][1] as! Edge // yellow, orange
        var edge4 = tiles[1][0][0] as! Edge // green, orange
        
        let edge1xTileColor = edge1.xTile.color
        
        edge1.xTile.color = edge2.yTile.color
        edge2.yTile.color = edge3.xTile.color
        edge3.xTile.color = edge4.yTile.color
        edge4.yTile.color = edge1xTileColor
        
        tiles[0][0][1] = edge1
        tiles[1][0][2] = edge2
        tiles[2][0][1] = edge3
        tiles[1][0][0] = edge4
        
        // TODO: remove
        corner1.updateColor()
        corner2.updateColor()
        corner4.updateColor()
        corner3.updateColor()
        
        edge1.updateColor()
        edge2.updateColor()
        edge3.updateColor()
        edge4.updateColor()
    }
    
    // makes the R move
    func turnR() {
        // corners
        var corner1 = tiles[0][2][0] as! Corner // white, green, red
        var corner2 = tiles[0][2][2] as! Corner // white, blue, red
        var corner3 = tiles[2][2][2] as! Corner // yellow, blue, red
        var corner4 = tiles[2][2][0] as! Corner // yellow, green, red
        
        let corner4xTileColor = corner4.xTile.color
        let corner4yTileColor = corner4.yTile.color
        
        corner4.xTile.color = corner3.yTile.color
        corner4.yTile.color = corner3.xTile.color
        
        corner3.xTile.color = corner2.yTile.color
        corner3.yTile.color = corner2.xTile.color
        
        corner2.xTile.color = corner1.yTile.color
        corner2.yTile.color = corner1.xTile.color

        corner1.xTile.color = corner4yTileColor
        corner1.yTile.color = corner4xTileColor
        
        tiles[0][2][0] = corner1
        tiles[0][2][2] = corner2
        tiles[2][2][2] = corner3
        tiles[2][2][0] = corner4
        
        // edges
        var edge1 = tiles[0][2][1] as! Edge // white, red
        var edge2 = tiles[1][2][2] as! Edge // blue, red
        var edge3 = tiles[2][2][1] as! Edge // yellow, red
        var edge4 = tiles[1][2][0] as! Edge // green, red

        let edge4xTileColor = edge4.yTile.color

        edge4.yTile.color = edge3.xTile.color
        edge3.xTile.color = edge2.yTile.color
        edge2.yTile.color = edge1.xTile.color
        edge1.xTile.color = edge4xTileColor

        tiles[0][2][1] = edge1
        tiles[1][2][2] = edge2
        tiles[2][2][1] = edge3
        tiles[1][2][0] = edge4
        
        // TODO: remove
        corner1.updateColor()
        corner2.updateColor()
        corner4.updateColor()
        corner3.updateColor()
        
        edge1.updateColor()
        edge2.updateColor()
        edge3.updateColor()
        edge4.updateColor()
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
    
    // MARK: - init 😬
    init() {
        tiles = Cube.initTiles()
        
        // MARK: - first layer
        
        // white, green, orange corner
        tiles[0][0].append(
            Corner(
                xTile:
                    Tile(
                        color: .white,
                        position: SCNVector3(x: -2 * Cube.offset, y: Cube.offset, z: -Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: -2 * Cube.offset, y: 0, z: 0),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube.offset, y: 0, z: -Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: -2 * Cube.offset, y: Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube.offset, y: 0, z: -3 * Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: -2 * Cube.offset, y: Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: -2 * Cube.offset, y: 0, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube.offset, y: 0, z: -5 * Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: 0, y: Cube.offset, z: -Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 0, y: 0, z: 0),
                        rotation: Cube.noRotation
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
                        position: SCNVector3(x: 0, y: Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.xRotation
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
                        position: SCNVector3(x: 0, y: Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 0, y: 0, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
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
                        position: SCNVector3(x: 2 * Cube.offset, y: Cube.offset, z: -Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 2 * Cube.offset, y: 0, z: 0),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube.offset, y: 0, z: -Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: 2 * Cube.offset, y: Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube.offset, y: 0, z: -3 * Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: 2 * Cube.offset, y: Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 2 * Cube.offset, y: 0, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube.offset, y: 0, z: -5 * Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: -3 * Cube.offset, y: -2 * Cube.offset, z: -Cube.offset),
                        rotation: Cube.yRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: -2 * Cube.offset, y: -2 * Cube.offset, z: 0),
                        rotation: Cube.noRotation
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
                        position: SCNVector3(x: -3 * Cube.offset, y: -2 * Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: -3 * Cube.offset, y: -2 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.yRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: -2 * Cube.offset, y: -2 * Cube.offset, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
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
                        position: SCNVector3(x: 0, y: -2 * Cube.offset, z: 0),
                        rotation: Cube.noRotation
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
                        position: SCNVector3(x: 0, y: -2 * Cube.offset, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
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
                        position: SCNVector3(x: 3 * Cube.offset, y: -2 * Cube.offset, z: -Cube.offset),
                        rotation: Cube.yRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 2 * Cube.offset, y: -2 * Cube.offset, z: 0),
                        rotation: Cube.noRotation
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
                        position: SCNVector3(x: 3 * Cube.offset, y: -2 * Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: 3 * Cube.offset, y: -2 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.yRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 2 * Cube.offset, y: -2 * Cube.offset, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
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
                        position: SCNVector3(x: -2 * Cube.offset, y: -5 * Cube.offset, z: -Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: -2 * Cube.offset, y: -4 * Cube.offset, z: 0),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube.offset, y: -4 * Cube.offset, z: -Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: -2 * Cube.offset, y: -5 * Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube.offset, y: -4 * Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: -2 * Cube.offset, y: -5 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: -2 * Cube.offset, y: -4 * Cube.offset, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -3 * Cube.offset, y: -4 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: 0, y: -5 * Cube.offset, z: -Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 0, y: -4 * Cube.offset, z: 0),
                        rotation: Cube.noRotation
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
                        position: SCNVector3(x: 0, y: -5 * Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.xRotation
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
                        position: SCNVector3(x: 0, y: -5 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 0, y: -4 * Cube.offset, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
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
                        position: SCNVector3(x: 2 * Cube.offset, y: -5 * Cube.offset, z: -Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 2 * Cube.offset, y: -4 * Cube.offset, z: 0),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube.offset, y: -4 * Cube.offset, z: -Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: 2 * Cube.offset, y: -5 * Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube.offset, y: -4 * Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.yRotation
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
                        position: SCNVector3(x: 2 * Cube.offset, y: -5 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 2 * Cube.offset, y: -4 * Cube.offset, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 3 * Cube.offset, y: -4 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.yRotation
                    ),
                scene: scene
            )
        )
    }
}

protocol Block {
    func addToScene(scene: SCNScene)
    
    func rotate(by worldRotation: SCNVector4, aroundTarget worldTarget: SCNVector3)
    
    func updateColor()
}
