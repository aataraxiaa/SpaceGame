//
//  GameScene.swift
//  SpaceGame
//
//  Created by Pete Smith on 18/02/2017.
//  Copyright © 2017 Pete Smith. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

class SpaceScene: SKScene {
    
    
    let spaceman = SKSpriteNode(imageNamed: ImageAsset.spaceman.rawValue)
    let planet = SKSpriteNode(imageNamed: ImageAsset.planet.rawValue)
    let background = SKSpriteNode(imageNamed: ImageAsset.space1.rawValue)
    
    /// Override this to create the scenes contents
    ///
    /// - Parameter view: The view the SKView is moving to
    override func didMove(to view: SKView) {
        
        // Background color
        backgroundColor = SKColor.black
        
        // Add background
        addBackground()
        
        // Add our planet
        addPlanet()
        
        // Start rotation
        startRotatePlanet()
        
        // Add spaceman
        addSpaceMan()
        
        // Set up physics
        setupPhysics()
        setUpPlanetPhysics()
    }

    // Touch events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            self.touchDown(atPoint: touch.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}

private typealias TouchHandler = SpaceScene
fileprivate extension TouchHandler {
    
    enum ScreenSide {
        case left, right
    }
    
    // Move the spaceman relative to our touch position
    fileprivate func touchDown(atPoint pos : CGPoint) {
        
        let currentSpacemanPosition = spaceman.position
        
        // Our spaceman always moves up, either to the left or right
        switch touchScreenSide(forPosition: pos) {
        case .left:
            let newPosition = CGPoint(x: currentSpacemanPosition.x + 1, y: currentSpacemanPosition.y + 1)
            spaceman.position = newPosition
            
        case .right:
            let newPosition = CGPoint(x: currentSpacemanPosition.x - 1, y: currentSpacemanPosition.y + 1)
            spaceman.position = newPosition
        }
    }
    
    fileprivate func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    fileprivate func touchUp(atPoint pos : CGPoint) {
        
    }
    
    fileprivate func touchScreenSide(forPosition position: CGPoint) -> ScreenSide {
        
        if position.x > size.width/2 {
            return ScreenSide.right
        } else {
            return ScreenSide.left
        }
    }
}

private typealias SceneCreator = SpaceScene
fileprivate extension SceneCreator {
    
    fileprivate func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.8)
    }
    
    fileprivate func setUpPlanetPhysics() {
        
        // Create a radial gravity field
        let planetPhysicsField = SKFieldNode.radialGravityField()
        planetPhysicsField.strength = 0.2
        planetPhysicsField.falloff = -0.2
        planetPhysicsField.categoryBitMask = Constants.PhysicsCategories.gravityCategory
        
        // Add to planet
        planet.addChild(planetPhysicsField)
        
        spaceman.physicsBody?.fieldBitMask = Constants.PhysicsCategories.gravityCategory
    }
    
    fileprivate func addBackground() {
        
        let pointZero = CGPoint(x: 0, y: 0)
        background.anchorPoint = pointZero
        background.position = pointZero
        
        background.zPosition = Constants.Layer.background
        
        background.size = CGSize(width: size.width, height: size.height)
        addChild(background)
    }

    fileprivate func addPlanet() {
        
        let planetPosition = CGPoint(x: size.width/2, y: size.width/2)
        planet.position = planetPosition
        
        planet.zPosition = Constants.Layer.planet
        planet.size = CGSize(width: size.width/1.5, height: size.width/1.5)
        addChild(planet)
    }
    
    fileprivate func startRotatePlanet() {
    
        let timeInterval = TimeInterval(20)
        
        let fullCircle: CGFloat = 360
        let halfCircle: CGFloat = 180
        
        let angle = (fullCircle * .pi) / halfCircle
        
        let rotateAction = SKAction.rotate(byAngle: angle, duration: timeInterval)
        let repeatAction = SKAction.repeatForever(rotateAction)
        planet.run(repeatAction)
    }
    
    fileprivate func addSpaceMan() {
        
        let spaceManStartPosition = CGPoint(x: size.width/2, y:  size.height - 80)
        spaceman.position = spaceManStartPosition
        
        spaceman.zPosition = Constants.Layer.spaceman
        spaceman.size = CGSize(width: 40, height: 40)
        
        spaceman.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: ImageAsset.spaceman.rawValue), size: spaceman.size)
        spaceman.physicsBody?.affectedByGravity = false
        
        addChild(spaceman)
    }
}
