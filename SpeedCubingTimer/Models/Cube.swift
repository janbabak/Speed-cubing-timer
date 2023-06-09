//
//  Cube.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 09.06.2023.
//

import SceneKit

struct Cube {
    var tiles: [[[Block]]]
    var scene = SCNScene()
    
    // MARK: - Cube constatnts
    static let rotation90deg = 90.0 * Float.pi / 180.0
    static let offset = Float(Tile.size / 2.0)
    static let xRotation = SCNVector3(x: Cube.rotation90deg, y: 0, z: 0)
    static let yRotation = SCNVector3(x: 0, y: Cube.rotation90deg, z: 0)
    static let noRotation = SCNVector3(x: 0, y: 0, z: 0)
    
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
    }
    
    // middle piece of the cube - core (there is only 1 core) not rendered
    struct Core: Block {
        func addToScene(scene: SCNScene) {
            return
        }
    }
    

    struct Tile {
        var node = SCNNode()
        
        
        // MARK: - Tile constants
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
        }
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
                        position: SCNVector3(x: 0, y: Cube.offset, z: -Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 0, y: 0, z: 0),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -Cube.offset, y: 0, z: -Cube.offset),
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
                        position: SCNVector3(x: 0, y: Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -Cube.offset, y: 0, z: -3 * Cube.offset),
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
                        position: SCNVector3(x: 0, y: Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 0, y: 0, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -Cube.offset, y: 0, z: -5 * Cube.offset),
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
                        position: SCNVector3(x: 2 * Cube.offset, y: Cube.offset, z: -Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 2 * Cube.offset, y: 0, z: 0),
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
                        position: SCNVector3(x: 2 * Cube.offset, y: Cube.offset, z: -3 * Cube.offset),
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
                        position: SCNVector3(x: 2 * Cube.offset, y: Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 2 * Cube.offset, y: 0, z: -6 * Cube.offset),
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
                        position: SCNVector3(x: 4 * Cube.offset, y: Cube.offset, z: -Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 4 * Cube.offset, y: 0, z: 0),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 5 * Cube.offset, y: 0, z: -Cube.offset),
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
                        position: SCNVector3(x: 4 * Cube.offset, y: Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 5 * Cube.offset, y: 0, z: -3 * Cube.offset),
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
                        position: SCNVector3(x: 4 * Cube.offset, y: Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 4 * Cube.offset, y: 0, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 5 * Cube.offset, y: 0, z: -5 * Cube.offset),
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
                        position: SCNVector3(x: -Cube.offset, y: -2 * Cube.offset, z: -Cube.offset),
                        rotation: Cube.yRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 0, y: -2 * Cube.offset, z: 0),
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
                        position: SCNVector3(x: -Cube.offset, y: -2 * Cube.offset, z: -3 * Cube.offset),
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
                        position: SCNVector3(x: -Cube.offset, y: -2 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.yRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 0, y: -2 * Cube.offset, z: -6 * Cube.offset),
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
                        position: SCNVector3(x: 2 * Cube.offset, y: -2 * Cube.offset, z: 0),
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
                        position: SCNVector3(x: 2 * Cube.offset, y: -2 * Cube.offset, z: -6 * Cube.offset),
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
                        position: SCNVector3(x: 5 * Cube.offset, y: -2 * Cube.offset, z: -Cube.offset),
                        rotation: Cube.yRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 4 * Cube.offset, y: -2 * Cube.offset, z: 0),
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
                        position: SCNVector3(x: 5 * Cube.offset, y: -2 * Cube.offset, z: -3 * Cube.offset),
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
                        position: SCNVector3(x: 5 * Cube.offset, y: -2 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.yRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 4 * Cube.offset, y: -2 * Cube.offset, z: -6 * Cube.offset),
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
                        position: SCNVector3(x: 0, y: -5 * Cube.offset, z: -Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 0, y: -4 * Cube.offset, z: 0),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -Cube.offset, y: -4 * Cube.offset, z: -Cube.offset),
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
                        position: SCNVector3(x: 0, y: -5 * Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -Cube.offset, y: -4 * Cube.offset, z: -3 * Cube.offset),
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
                        position: SCNVector3(x: 0, y: -5 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 0, y: -4 * Cube.offset, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .orange,
                        position: SCNVector3(x: -Cube.offset, y: -4 * Cube.offset, z: -5 * Cube.offset),
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
                        position: SCNVector3(x: 2 * Cube.offset, y: -5 * Cube.offset, z: -Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 2 * Cube.offset, y: -4 * Cube.offset, z: 0),
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
                        position: SCNVector3(x: 2 * Cube.offset, y: -5 * Cube.offset, z: -3 * Cube.offset),
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
                        position: SCNVector3(x: 2 * Cube.offset, y: -5 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 2 * Cube.offset, y: -4 * Cube.offset, z: -6 * Cube.offset),
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
                        position: SCNVector3(x: 4 * Cube.offset, y: -5 * Cube.offset, z: -Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .green,
                        position: SCNVector3(x: 4 * Cube.offset, y: -4 * Cube.offset, z: 0),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 5 * Cube.offset, y: -4 * Cube.offset, z: -Cube.offset),
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
                        position: SCNVector3(x: 4 * Cube.offset, y: -5 * Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 5 * Cube.offset, y: -4 * Cube.offset, z: -3 * Cube.offset),
                        rotation: Cube.yRotation
                    ),
                scene: scene
            )
        )
        
        // yellow, blue, red corner
        tiles[0][2].append(
            Corner(
                xTile:
                    Tile(
                        color: .yellow,
                        position: SCNVector3(x: 4 * Cube.offset, y: -5 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.xRotation
                    ),
                yTile:
                    Tile(
                        color: .blue,
                        position: SCNVector3(x: 4 * Cube.offset, y: -4 * Cube.offset, z: -6 * Cube.offset),
                        rotation: Cube.noRotation
                    ),
                zTile:
                    Tile(
                        color: .red,
                        position: SCNVector3(x: 5 * Cube.offset, y: -4 * Cube.offset, z: -5 * Cube.offset),
                        rotation: Cube.yRotation
                    ),
                scene: scene
            )
        )
    }
}

protocol Block {
    func addToScene(scene: SCNScene) -> Void
}
