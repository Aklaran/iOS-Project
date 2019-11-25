
import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation

var levelNum = 1

class GameScene: SKScene, SKPhysicsContactDelegate {
  /* Class Constants */
  // Game Facts
  static let FPS = 60
  static let WIDTH = UIScreen.main.bounds.width
  static let HEIGHT = UIScreen.main.bounds.height
  
  // Game Settings
  static let HORIZON : CGFloat = 100
  static let LEVELS: [Level] = [ // I am working on improvining initialization of levels and spawners
    BoundedLevel(
      spawners: [
        try! Spawner(
          maxSpawned: 6,
          minSpawned: 5,
          maxConcurrent: 1,
          cooldown: 0.5,
          expectedDuration: 600,
          getNewSpawn: Bat.init)
      ],
      cartSpeed: 0.1,
      flashlightDecay: 0.0001
    ),
    BoundedLevel(
      spawners: [
        try! Spawner(
          maxSpawned: 1000,
          minSpawned: 500,
          maxConcurrent: 2,
          cooldown: 1,
          expectedDuration: 6000,
          getNewSpawn: Bat.init)
      ],
      cartSpeed: 0.1,
      flashlightDecay: 0.001
    )
    // todo: create an unbounded level so that this does not crash
  ]
  
  // Game Things
  static let AUDIO_MANAGER = AudioManager()
  
  /* Instance Variables */
  // Explict
  var oncomers: Set<Oncomer> = Set()
  var currentLevelIndex: Int = 0
  var backgroundSize: CGFloat = 0;
  
  // Dynamic
  var currentLevel: Level {
    get {
      return GameScene.LEVELS[currentLevelIndex]
    }
  }
  
  /* ... eh ... */
  // not sure if these should stay...
  let THIRD_SCREEN_WIDTH = UIScreen.main.bounds.width / 3
  let GOLDEN_RATIO = CGFloat(1.61803398875)
  
  static let tracksSoundFile = Bundle.main.path(forResource: "tracks.mp3", ofType: nil)!
  
  let background:Background = Background()
  
  let cart:Cart = Cart()
  
//  let maxLevels = 3
  var meters : CGFloat = 0 {
    didSet {
      progressLabel!.text = String(Int(meters)) + " meters"
    }
  }
  
  var velocity : CGFloat = 0.02
  
  let motionManager = CMMotionManager()
  
  var lives = [SKSpriteNode]();
  
  var rider: Rider? = nil
  
  var battery: BatteryBar? = BatteryBar()
  
  var progressLabel : SKLabelNode? = nil
  
  override func didMove(to view: SKView) {
    initializeBackground()
    
    initializeMineCart()
    
    initializeRider()
    
    initializeHearts()
    
    initializeSounds()
    
    initializeProgressFeedback()
    
    initializeBattery()
  }
  
  func initializeMineCart() {
    cart.anchorPoint = CGPoint(x: 0.5, y: 0);
    cart.position = CGPoint(x: GameScene.WIDTH/2, y: 0);
    cart.size.height = backgroundSize * 0.90;
    cart.zPosition = 1

    addChild(cart)
  }
  
  func initializeBattery() {
    battery?.anchorPoint = CGPoint(x: 0.5, y: 0);
    battery?.position = CGPoint(x: GameScene.WIDTH/2, y: GameScene.HEIGHT - (battery?.size.height)!/4);
    battery?.size.height = (battery?.size.height)!/4;
    battery?.size.width = (battery?.size.width)!/4;

    addChild(battery!)
  }
  
  func initializeProgressFeedback() {
    progressLabel = SKLabelNode(text: " meters")
    progressLabel?.position = CGPoint(
      x: UIScreen.main.bounds.width / 7 * 6,
      y: 9 * UIScreen.main.bounds.height / 10
    )
    addChild(progressLabel!)
  }
  
  func initializeSounds() {
    let tracksSound = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: GameScene.tracksSoundFile))
    tracksSound.numberOfLoops = -1
    tracksSound.volume = 0.05
    tracksSound.play()
    //tracksSound.numberOfLoops = -1
//    tracksSound.volume = 0.1
//    tracksSound.play()
    
//    var e = audioManager.createEmitter(soundFile: GameScene.tracksSoundFile, maxZMagnitude: 10)
////    e = Emitter(soundFile: GameScene.tracksSoundFile, maxZMagnitude: 10)
//    e.isRepeated = true
//    e.volume = 0.05
//    e.start()
//    e.updatePosition(rider!.position)
    
  }
  
  func initializeBackground() {
    background.anchorPoint = CGPoint(x: 0.5, y: 0)
    background.position = CGPoint(x: size.width/2, y: size.height)
    background.zPosition = -999
    // Sets background vanishing point to below half the screen for 3D depth
    background.size.height = self.frame.size.height / (GOLDEN_RATIO * 2);
    backgroundSize = (background.size.height);
    addChild(background)
    self.backgroundColor = .black
    // background.isHidden = true // no sight by default
  }
  
  func initializeRider() {
    let flashlight = Flashlight(battery: CGFloat(1), brightness: 0.1)
    flashlight.position.y = GameScene.HEIGHT
    
    rider = Rider(audioManager: GameScene.AUDIO_MANAGER, motionManager: motionManager, flashlight: flashlight, cartHeight: Int(cart.size.height))
    rider!.zPosition = 2
    addChild(rider!)
//    rider?.isHidden = true // no sight by default
  }
  
  func initializeHearts() {
    for i in 0 ..< rider!.lives {
      let newHeart = SKSpriteNode(imageNamed: "heart");
      newHeart.anchorPoint = (CGPoint(x: 0.5, y: 0))
      newHeart.position = CGPoint(x: CGFloat(newHeart.size.width/2 + CGFloat(i) * 100), y: (GameScene.HEIGHT - newHeart.size.height));
      lives.append(newHeart)
      addChild(newHeart)
    }
  }
  
  func touchDown(atPoint pos : CGPoint) {}
  func touchMoved(toPoint pos : CGPoint) {}
  func touchUp(atPoint pos : CGPoint) {}
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    
    // make sure we have a rider
    guard let rider = rider else {
      print("No rider!")
      return
    }
    
    // decrease flashlight battery
    rider.flashlight?.drainBattery(amount: currentLevel.getFlashlightDecay())
    
    // for each oncomer
    for oncomer in oncomers {
      
      // move forward
      oncomer.move(withAdditionalDistance: currentLevel.getCartSpeed())
      
      // check collisions
      if withinStrikingDistance(of: oncomer) {
        if oncomer.collidesWith(position: rider.headPosition) {
          oncomer.applyCollisionEffects(to: self)
        } else {
          oncomer.applyPassEffects(to: self)
        }
      }
      
      // check if gone
      if oncomer.isGone() {
        oncomer.applyGoneEffects(to: self)
      }
      
    }
    
    // check if game is over
    if rider.isDead() {
      endGame()
    }
    
    // check if level is over - if spawning is done and all the oncomers are gone
    if currentLevel.isDone() && oncomers.count == 0 {
      currentLevelIndex = currentLevelIndex + 1
    }
    
    // get anything newly spawned
    let newOncomers = currentLevel.spawn()
    oncomers = oncomers.union(newOncomers)
    for oncomer in newOncomers {
      addChild(oncomer)
    }
    
    // move the cart
    meters = meters + velocity // todo: replace with point system
    
  }
  
  func endGame() {
    // despawn all the oncomers
    for oncomer in oncomers {
      oncomer.despawn()
    }
    
    // transision scenes
    let gameOverScene = GameOverScene(size: size)
    gameOverScene.scaleMode = scaleMode
    gameOverScene.distance = meters // pass distance traveled for the leaderboard
    let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
    view?.presentScene(gameOverScene,transition: transitionType)
  }
  
  func newGame() {
    let gameOverScene = StartGameScene(size: size)
    gameOverScene.scaleMode = scaleMode
    let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
    view?.presentScene(gameOverScene,transition: transitionType)
  }
  
  private func withinStrikingDistance(of node: SKNode) -> Bool {
    return abs(node.zPosition) <= node.speed + currentLevel.getCartSpeed()
  }
}
