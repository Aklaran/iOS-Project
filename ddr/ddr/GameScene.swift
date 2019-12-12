
import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {
  /* Class Constants */
  // Game Facts
  static let FPS = 60
  static let WIDTH = UIScreen.main.bounds.width
  static let HEIGHT = UIScreen.main.bounds.height
  static let TRACKS_FILE = Bundle.main.path(forResource: "tracks.mp3", ofType: nil)!
  
  // Game Settings
  static let HORIZON: CGFloat = 100
  static let CART_SPEED_POINT_CONVERSION: CGFloat = 10
  static let BAT_SPEED_POINT_CONVERSION: CGFloat = 100
  
  // function to allow game levels to be reset
  static func getLevels() -> [Level] {
    return [
      TrainingLevel(
        id: "BatTraining",
        steps: [

          MessageStep(lines: ["Let's practice dodging bats.", "Tilt your device to avoid them."], duration: 3),
          try! OncomerStep(
            oncomer: Bat.getTrainingBat(position: ScreenThird.LEFT),
            desireToHit: false
          ),
          try! OncomerStep(
            oncomer: Bat.getTrainingBat(position: ScreenThird.MIDDLE),
            desireToHit: false
          ),
          try! OncomerStep(
            oncomer: Bat.getTrainingBat(position: ScreenThird.RIGHT),
            desireToHit: false
          ),
          MessageStep(text: "Alright, here they come!", duration: 3)
        ],
        cartSpeed: 0,
        flashlightDecay: 0
      ),
      StandardLevel(
        // simple level to get used to bats
        spawners: [
          Spawner(
            maxSpawned: 3,
            minSpawned: 2,
            maxConcurrent: 1,
            cooldown: 0.3,
            getNewSpawn: Bat.spawningFunc(),
            pSpawn: 1
          )
        ],
        cartSpeed: 0.1,
        flashlightDecay: 0.001
      ),
      TrainingLevel(
        id: "BatteryTraining",
        steps: [
          MessageStep(lines: ["As your headlight dims,", "grab batteries to recharge!"] , duration: 3),
          try! OncomerStep(
            oncomer: Battery(position: ScreenThird.RIGHT),
            desireToHit: true
          ),
          MessageStep(text: "Nice work!", duration: 3)
        ],
        cartSpeed: 0,
        flashlightDecay: 0
      ),
      StandardLevel(
        spawners: [
          Spawner(
            maxSpawned: 4,
            minSpawned: 3,
            maxConcurrent: 1,
            cooldown: 0,
            getNewSpawn: Bat.spawningFunc(speed: 1.2),
            pSpawn: 0.005
          ),
          Spawner(
            maxSpawned: 1000,
            minSpawned: 1,
            maxConcurrent: 1,
            cooldown: 1,
            getNewSpawn: Battery.spawningFunc(),
            pSpawn: 0.0015
          )
        ],
        cartSpeed: 0.1,
        flashlightDecay: 0.0003
      ),
      TrainingLevel(
        id: "HeartTraining",
        steps: [
          MessageStep(lines: ["Also, collect extra lives!", "(you can store up to 3)"] , duration: 3),
          try! OncomerStep(
            oncomer: Heart(position: ScreenThird.LEFT),
            desireToHit: true
          ),
          MessageStep(text: "Great job!", duration: 3)
        ],
        cartSpeed: 0,
        flashlightDecay: 0
      ),
      StandardLevel(
        spawners: [
          Spawner(
            maxSpawned: 6,
            minSpawned: 5,
            maxConcurrent: 2,
            cooldown: 0,
            getNewSpawn: Bat.spawningFunc(),
            pSpawn: 0.007
          ),
          Spawner(
            maxSpawned: 1,
            minSpawned: 1,
            maxConcurrent: 1,
            cooldown: 0.5,
            getNewSpawn: Heart.spawningFunc(),
            pSpawn: 0.001
          ),
          Spawner(
            maxSpawned: 3,
            minSpawned: 1,
            maxConcurrent: 1,
            cooldown: 1,
            getNewSpawn: Battery.spawningFunc(),
            pSpawn: 0.00125
          )
        ],
        cartSpeed: 0.1,
        flashlightDecay: 0.0007
      ),
      StandardLevel(
        spawners: [
          Spawner(maxSpawned: -1, minSpawned: 0, maxConcurrent: 3, cooldown: 0.75, getNewSpawn: Bat.spawningFunc(speed: 1.5), pSpawn: 0.015),
          Spawner(
            maxSpawned: -1,
            minSpawned: 1,
            maxConcurrent: 1,
            cooldown: 0.5,
            getNewSpawn: Heart.spawningFunc(),
            pSpawn: 0.0006
          ),
          Spawner(
            maxSpawned: -1,
            minSpawned: 1,
            maxConcurrent: 1,
            cooldown: 1,
            getNewSpawn: Battery.spawningFunc(),
            pSpawn: 0.003
          )
        ],
        cartSpeed: 0.15,
        flashlightDecay: 0.0015
      )
    ]
  }
  
  // Game Things
  static let AUDIO_MANAGER = AudioManager()
  
  let background: Background = Background()
  let cart: Cart = Cart()
  let motionManager = CMMotionManager()
  
  /* Instance Variables */
  var oncomers: Set<Oncomer> = Set()
  var currentLevelIndex: Int = 0
  
  var levels: [Level] = GameScene.getLevels()
  var levelNodes: [SKNode] = []

  var backgroundSize: CGFloat = 0;
  var tracksSound: AVAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: GameScene.TRACKS_FILE))
  var lives = [SKSpriteNode]();
  var rider: Rider? = nil
  var battery: BatteryBar? = BatteryBar(maxCharge: 3)
  var scoreLabel: SKLabelNode? = nil
  var score: CGFloat = 0 {
    didSet {
      scoreLabel?.text = "\(Int(score)) points"
    }
  }
  
  // Dynamic
  var currentLevel: Level {
    get {
      return levels[currentLevelIndex]
    }
  }
  
  /* ... eh ... */
  // not sure if these should stay...
  let THIRD_SCREEN_WIDTH = UIScreen.main.bounds.width / 3
  let GOLDEN_RATIO = CGFloat(1.61803398875)
  
  // MARK: Initialization
  
  override func didMove(to view: SKView) {
    initializeBackground()

    initializeMineCart()

    initializeRider()
    // also inits flashlight and battery

    initializeHearts()
    
    initializeSounds()
    
    initializeProgressFeedback()

    initializeLevels()
  }
  
  func initializeLevels() {
    levelNodes = currentLevel.nodes()
    for node in levelNodes {
      addChild(node)
    }
  }
  
  func initializeMineCart() {
    cart.anchorPoint = CGPoint(x: 0.5, y: 0);
    cart.position = CGPoint(x: GameScene.WIDTH/2, y: 0);
    cart.size.height = backgroundSize;
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
    scoreLabel = SKLabelNode(text: "0 points")
    scoreLabel?.fontName = "PressStart2P-Regular"
    scoreLabel?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
    scoreLabel?.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
    scoreLabel?.position = CGPoint(
      x: GameScene.WIDTH,
      y: GameScene.HEIGHT
    )
    addChild(scoreLabel!)
  }
  
  func initializeSounds() {
    tracksSound.volume = 0.05
    tracksSound.numberOfLoops = -1
    tracksSound.play()
  }
  
  func initializeBackground() {
    background.anchorPoint = CGPoint(x: 0.5, y: 0)
    background.position = CGPoint(x: size.width/2, y: 0)
    background.zPosition = -999
    // Sets background vanishing point to below half the screen for 3D depth
    background.size.height = self.frame.size.height / 2
    background.size.width = self.frame.size.width / 2
    backgroundSize = (background.size.height);
    addChild(background)
    self.backgroundColor = .black
    // background.isHidden = true // no sight by default
  }
  
  func initializeRider() {
    initializeBattery()
    
    var flashlight : Flashlight
    
    // give the flashlight the battery indicator if it exists
    if let battery = battery {
      flashlight = Flashlight(battery: battery, maxBattery: CGFloat(1), brightness: 0.1)
    } else {
      flashlight = Flashlight(maxBattery: CGFloat(1), brightness: 0.1)
    }
    
    flashlight.position.y = GameScene.HEIGHT
    
    rider = Rider(audioManager: GameScene.AUDIO_MANAGER, motionManager: motionManager, flashlight: flashlight, cartHeight: Int(cart.size.height))
    addChild(rider!)
  }
  
  func initializeHearts() {
    for _ in 0 ..< rider!.lives {
      drawHeart()
    }
  }
  
  func drawHeart() {
    let newHeart = SKSpriteNode(imageNamed: "heart");
    newHeart.anchorPoint = (CGPoint(x: 0.5, y: 0))
    newHeart.position = CGPoint(x: CGFloat(newHeart.size.width/2 + CGFloat(lives.count) * 100), y: (GameScene.HEIGHT - newHeart.size.height));
    lives.append(newHeart)
    addChild(newHeart)
  }
  
  // MARK: builtin scene kit functions
  func touchDown(atPoint pos : CGPoint) {}
  func touchMoved(toPoint pos : CGPoint) {}
  func touchUp(atPoint pos : CGPoint) {}
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
  
  // MARK: the update loop
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    
    // only do this if the level does not say we should pause
    if !currentLevel.shouldWait(self) {
      currentLevel.alertNotWaiting() // and let the level know what we do
      
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
        if riderWithinStrikingDistance(of: oncomer) && !currentLevel.shouldWait(self) {
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
      
      // get anything newly spawned
      let newOncomers = currentLevel.spawn()
      oncomers = oncomers.union(newOncomers)
      for oncomer in newOncomers {
        addChild(oncomer)
      }
      
      // update the score
      score += GameScene.CART_SPEED_POINT_CONVERSION * currentLevel.getCartSpeed()
      
    }
    else {
      currentLevel.alertWaiting() // and let the level know if we are wating on it
    }
    
    // check if level is over - if spawning is done and all the oncomers are gone
    if currentLevel.isDone() && oncomers.count == 0 {
      nextLevel()
    }
    
  }
  
  // MARK: game managment
  func nextLevel() {
    for node in levelNodes {
      node.removeFromParent()
    }
    currentLevelIndex = currentLevelIndex + 1
    levelNodes = currentLevel.nodes()
    for node in levelNodes {
      addChild(node)
    }
  }
  
  func endGame() {
    // despawn all the oncomers
    for oncomer in oncomers {
      oncomer.despawn()
    }
    
    // transision scenes
    let gameOverScene = GameOverScene(size: size)
    gameOverScene.scaleMode = scaleMode
    gameOverScene.score = score // pass distance traveled for the leaderboard
    let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
    view?.presentScene(gameOverScene,transition: transitionType)
  }
  
  func newGame() {
    // reset leveling
    levels = GameScene.getLevels()
    currentLevelIndex = -1; // hacky but works
    nextLevel()
    
    // reset score
    score = 0
    
    // other stuff
    let gameOverScene = StartGameScene(size: size)
    gameOverScene.scaleMode = scaleMode
    let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
    view?.presentScene(gameOverScene,transition: transitionType)
  }
  
  // MARK: helper functions
  func riderWithinStrikingDistance(of oncomer: Oncomer) -> Bool {
    return oncomer.zPosition >= 0
      && oncomer.zPosition < oncomer.speed + currentLevel.getCartSpeed()
  }
  
}
