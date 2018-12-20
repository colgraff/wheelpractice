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
  //
  // No air quotes necessary, for each instance of `WheelScene` this is
  // the initial (and only) creation of `Wheel`
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
//
// Actually it defines a class which will contain a `WheelScene`,
// allowing an instance of `WheelView` to control a `WheelScene`
class WheelView: SKView {
  
  //Not really clear on this
  //Creating an instance of wheel with parameters from WheelScene?
  //
  // A computed property which casts the `SKScene` returned by `self.scene`
  // into a `WheelScene` which has a `wheel` property and returns that property.
  //
  // It's a convienience to be able to easily access the `Wheel` instance.
  // That way we can cause it to spin whenever we want.
  var wheel: Wheel { return (self.scene as! WheelScene).wheel }
  // Based on swift documentation, CGRect is a struct?
  // I read this as initialize a frame with parameters stored in CGRect
  //
  // This initializes the class that contains it, in this case `WheelView`.
  // it takes in a `frame` parameter and tells the superclass `SKView` to
  // use it to initialize itself.
  override init(frame: CGRect) {
    super.init(frame: frame)
    //Calls func that creates and displays the wheel
    //Parameters of wheel set in wheel scene
    //
    // Correct
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    //Creates wheel
    //
    // Creates the subclass of `SKScene` that controls a `Wheel`
    let scene = WheelScene(size: frame.size)
    self.backgroundColor = .white
    //Displays wheel
    //
    // Tells the subclass of `SKScene` to do what it needs to do in order
    // to run itself and display itself for the user.
    self.presentScene(scene)
  }
}
