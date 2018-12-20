import UIKit
import SpriteKit

func centerFrame(_ frame: CGRect) -> CGPoint {
  return CGPoint(x: (frame.maxX - frame.minX) / 2,
                 y: (frame.maxY - frame.minY) / 2)
}

let wheelSize: CGFloat = 400

class Wedge: SKShapeNode {
  let size: CGFloat
  let angle: CGFloat
  let label: SKLabelNode

  init(size: CGFloat, angle: CGFloat, label: SKLabelNode) {
    self.size = size
    self.angle = angle
    self.label = label
    super.init()

    self.label.position = CGPoint(x: 0, y: size * 3 / 4)
    addChild(self.label)
    let halfAngle = angle / 2
    let centerAngle = CGFloat.pi / 2
    let path = UIBezierPath(arcCenter: CGPoint.zero,
                            radius: size,
                            startAngle: centerAngle - halfAngle,
                            endAngle: centerAngle + halfAngle,
                            clockwise: true)
    path.addLine(to: CGPoint.zero)
    path.close()
    self.path = path.cgPath
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class Wheel: SKShapeNode {
  let size: CGFloat = 1024
  let colors: [UIColor]

  init(colors: [UIColor]) {
    self.colors = colors
    super.init()

    let wedges = colors.count
    let angle = 2 * CGFloat.pi / CGFloat(wedges)

    for start in 0..<wedges {
      let label = SKLabelNode()
      label.fontSize *= size / 256
      switch start {
      case 1, 3, 5: label.text = "Yes"
      default     : label.text = "No"
      }
      let wedge = Wedge(size: size, angle: angle, label: label)
      wedge.zRotation = CGFloat(start) * angle
      wedge.fillColor = colors[start]
      addChild(wedge)
    }

    self.physicsBody = SKPhysicsBody(circleOfRadius: size,
                                     center: centerFrame(self.frame))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class WheelScene: SKScene {
  //"Initial" creation of wheel
  let wheel: Wheel = Wheel(colors: [.red, .blue, .green, .white, .purple, .brown])

  override init(size: CGSize) {
    super.init(size: size)
    self.scaleMode = .aspectFit
    self.physicsWorld.gravity = CGVector.zero

    wheel.position = centerFrame(self.frame)
    wheel.physicsBody?.angularVelocity = 0
    wheel.physicsBody?.angularDamping = 0.5
    let scale = min(size.width, size.height) / (2 * wheel.size)
    wheel.xScale = scale
    wheel.yScale = scale

    self.addChild(wheel)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
//Creates an instance of WheelScene which allows you to modify values from outside WheelScene?
class WheelView: SKView {
  
  //Not really clear on this
  //Creating an instance of wheel with parameters from WheelScene?
  var wheel: Wheel { return (self.scene as! WheelScene).wheel }
 // Based on swift documentation, CGRect is a struct?
 // I read this as initialize a frame with parameters stored in CGRect
  override init(frame: CGRect) {
    super.init(frame: frame)
  //Calls func that creates and displays the wheel
  //Parameters of wheel set in wheel scene
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    //Creates wheel
    let scene = WheelScene(size: frame.size)
    self.backgroundColor = .white
    //Displays wheel
    self.presentScene(scene)
  }
}
