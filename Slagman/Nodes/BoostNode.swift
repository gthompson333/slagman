//
//  BoostNode.swift
//  Slagman
//
//  Created by Greg M. Thompson on 3/12/18.
//  Copyright © 2018 Gregorius T. All rights reserved.
//

import SpriteKit

class BoostNode: SKSpriteNode {
  var originalPosition: CGPoint!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    originalPosition = position
    
    if let patrolDistance = userData?["patrols"] as? Int {
      patrolling(distance: patrolDistance)
    }
    
    if let distance = userData?["wanders"] as? Int {
      wandering(distance: distance)
    }
  }
  
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
  }
  
  private func patrolling(distance: Int) {
    let move = SKAction.moveBy(x: CGFloat(distance), y: 0, duration: 2.0)
    let repeatMove = SKAction.repeatForever(SKAction.sequence([move, move.reversed()]))
    run(repeatMove)
  }
  
  private func wandering(distance: Int) {
    let move1 = SKAction.move(to: CGPoint(x: originalPosition.x + CGFloat(distance), y: originalPosition.y + CGFloat(distance)), duration: 1.5)
    let move2 = SKAction.move(to: CGPoint(x: originalPosition.x + CGFloat(2*distance), y: originalPosition.y), duration: 1.5)
    let move3 = SKAction.move(to: CGPoint(x: originalPosition.x + CGFloat(distance), y: originalPosition.y - CGFloat(distance)), duration: 1.5)
    let move4 = SKAction.move(to: CGPoint(x: originalPosition.x, y: originalPosition.y), duration: 1.5)
    
    let repeatMove = SKAction.repeatForever(SKAction.sequence([move1, move2, move3, move4]))
    run(repeatMove)
  }
  
  func applyEffects() {
    var explode: SKEmitterNode? = nil
    
    // A finish gate power node.
    if userData?["finish"] != nil {
      guard let emitterNode = SKEmitterNode(fileNamed: "challengefinishexplosion") else {
        assertionFailure("Missing challengefinishexplosion.sks particles file.")
        return
      }
      explode = emitterNode
    }
      // Regular power node.
    else {
      if userData?["blockbucket"] != nil || userData?["blockgate"] != nil {
        if let parentNode = parent {
          for child in parentNode.children {
            if child.userData?["gravityprone"] != nil {
              if let physics = child.physicsBody {
                physics.affectedByGravity = true
                
                if let xvelocity = child.userData?["xvelocity"] as? CGFloat, let yvelocity = child.userData?["yvelocity"] as? CGFloat {
                  physics.velocity.dy = yvelocity
                  physics.velocity.dx = xvelocity
                }
              }
            }
          }
        }
      }
      guard let emitterNode = SKEmitterNode(fileNamed: "powerboostexplosion") else {
        assertionFailure("Missing powerboostexplosion.sks particles file.")
        return
      }
      explode = emitterNode
    } // Regular power node.
    
    if explode != nil {
      explode!.position = position
      parent?.addChild(explode!)
      removeFromParent()
    }
  }
}
