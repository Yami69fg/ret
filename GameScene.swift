import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    weak var screen: MainGameViewControllerForGameScene?
    
    var movableObject: SKSpriteNode!
    var ballImages = ["Ball1", "Ball2", "Ball3"]
    var countdownLabel: SKLabelNode!
    var countdown: Int = 15
    var scoreLabel: SKLabelNode!
    var score: Int = 0
    var lastMovableObjectPosition: CGFloat = 0
    var balls: [SKSpriteNode] = []
    var bestScore: Int = 0
    var scoreBackground: SKSpriteNode!
    var bestScoreLabel: SKLabelNode!
    var gameIsPaused: Bool = false
    var ballTimer: SKAction?
    var countdownTimer: SKAction?
    var bonusOrAntiBonus: SKSpriteNode!
    var selectedLevel: Int = 0
    var backG: String = ""
    var levelTime: Int = 0
    private var isVibroOn: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isVibroOn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isVibroOn")
        }
    }
    
    private var isSoundOn: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isSoundOn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isSoundOn")
        }
    }
    
    init(size: CGSize, level: Int, backG: String, targetTime: Int) {
        self.selectedLevel = level
        self.backG = backG
        if level > 6 {
            self.countdown = 60
            self.levelTime = targetTime
        } else {
            self.countdown = targetTime
            self.levelTime = targetTime
        }
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        setupBackground()
        let gameField = createGameField()
        setupPhysics(for: gameField)
        addChild(gameField)
        createMovableObject()
        
        removeBonuses()
        
        let delay = SKAction.wait(forDuration: 0.5)
        let startGameAction = SKAction.run { [weak self] in
            self?.createFallingBall()
            self?.startBallTimer()
            self?.setupCountdownLabel()
            self?.startCountdown()
            self?.setupScoreLabel()
            self?.setupBestScoreLabel()
            self?.startBonusTimer()
            self?.physicsWorld.contactDelegate = self
            self?.lastMovableObjectPosition = self?.movableObject.position.x ?? 0
        }

        run(SKAction.sequence([delay, startGameAction]))
    }

    func setupBackground() {
        let background = SKSpriteNode(imageNamed: backG)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        let scale = max(size.width / background.size.width, size.height / background.size.height)
        background.size = CGSize(width: background.size.width * scale, height: background.size.height * scale)
        background.zPosition = -1
        addChild(background)
        
    }

    func createGameField() -> SKSpriteNode {
        scoreBackground = SKSpriteNode(imageNamed: "ScoreBG")
        scoreBackground.size = CGSize(width: size.width*0.5, height: size.height*0.075)
        scoreBackground.position = CGPoint(x: size.width/2, y: size.height * 0.9)
        scoreBackground.zPosition = 0
        addChild(scoreBackground)
        
        let gameField = SKSpriteNode(imageNamed: "GameField")
        gameField.name = "GameField"
        gameField.position = CGPoint(x: size.width/2, y: size.height/2)
        gameField.size = CGSize(width: size.width * 0.85, height: size.height * 0.725)
        gameField.color = .white
        gameField.zPosition = 0
        return gameField
    }

    func setupPhysics(for node: SKSpriteNode) {
        let physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(
            x: -node.size.width / 2,
            y: -node.size.height / 2,
            width: node.size.width,
            height: node.size.height
        ))
        physicsBody.restitution = 1.0
        physicsBody.friction = 0.0
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = false
        node.physicsBody = physicsBody
    }

    func createMovableObject() {
        movableObject = SKSpriteNode(imageNamed: "Lapta")
        movableObject.size = CGSize(width: size.width * 0.25, height: size.height * 0.04)
        movableObject.position = CGPoint(x: size.width/2, y: size.height * 0.2)
        movableObject.zPosition = 1
        
        let physicsBody = SKPhysicsBody(rectangleOf: movableObject.size)
        physicsBody.restitution = 1.05
        physicsBody.friction = 0.0
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = 1 << 2
        movableObject.physicsBody = physicsBody

        addChild(movableObject)
    }

    func createFallingBall() {
        let fallingBall = SKSpriteNode(imageNamed: getRandomBallImage())
        fallingBall.size = CGSize(width: size.width * 0.1, height: size.width * 0.1)
        fallingBall.position = CGPoint(x: CGFloat.random(in: size.width * 0.35...size.width * 0.7), y: size.height * 0.75)
        fallingBall.zPosition = 1
        
        let physicsBody = SKPhysicsBody(circleOfRadius: fallingBall.size.width / 2)
        physicsBody.restitution = 0.0
        physicsBody.friction = 0.0
        physicsBody.affectedByGravity = true
        physicsBody.isDynamic = true
        physicsBody.categoryBitMask = 1 << 1
        physicsBody.contactTestBitMask = 1 << 2
        physicsBody.collisionBitMask = ~(1 << 1)
        fallingBall.physicsBody = physicsBody

        addChild(fallingBall)
        balls.append(fallingBall)
    }
    
    func startBallTimer() {
        let wait = SKAction.wait(forDuration: 10.0)
        let createBall = SKAction.run { [weak self] in
            self?.createFallingBall()
        }
        let sequence = SKAction.sequence([wait, createBall])
        run(SKAction.repeatForever(sequence))
    }

    func getRandomBallImage() -> String {
        return ballImages.randomElement() ?? "Ball1"
    }

    func setupCountdownLabel() {
        countdownLabel = SKLabelNode(text: "\(countdown)")
        countdownLabel.zPosition = 1
        countdownLabel.fontSize = 182
        countdownLabel.fontName = "A25-SQUANOVA"
        countdownLabel.color = .white
        countdownLabel.alpha = 0.3
        countdownLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(countdownLabel)
    }

    func startCountdown() {
        let wait = SKAction.wait(forDuration: 1.0)
        let updateCountdown = SKAction.run { [weak self] in
            guard let self = self else { return }
            if self.countdown > 0 {
                self.countdown -= 1
                self.countdownLabel.text = "\(self.countdown)"
            } else {
                self.removeAllActions()
            }
        }
        let sequence = SKAction.sequence([wait, updateCountdown])
        run(SKAction.repeatForever(sequence))
    }

    func setupScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.zPosition = 1
        scoreLabel.fontSize = 20
        scoreLabel.fontName = "A25-SQUANOVA"
        scoreLabel.color = .white
        scoreLabel.position = CGPoint(x: -size.width * 0.125, y: -10)
        scoreBackground.addChild(scoreLabel)
    }
    
    func setupBestScoreLabel() {
        bestScore = UserDefaults.standard.integer(forKey: "BestScore")
        bestScoreLabel = SKLabelNode(text: "Best: \(bestScore)")
        bestScoreLabel.zPosition = 1
        bestScoreLabel.fontSize = 20
        bestScoreLabel.fontName = "A25-SQUANOVA"
        bestScoreLabel.color = .white
        bestScoreLabel.position = CGPoint(x: size.width * 0.125, y: -10)
        scoreBackground.addChild(bestScoreLabel)
    }

    func updateScore() {
        if isSoundOn {
            let soundAction = SKAction.playSoundFileNamed("scoreSound.wav", waitForCompletion: false)
            run(soundAction)
        }
        score += 1
        scoreLabel.text = "Score: \(score)"
        if score > bestScore {
            bestScore = score
            bestScoreLabel.text = "Best: \(bestScore)"
            UserDefaults.standard.set(bestScore, forKey: "BestScore")
        }
    }
    

    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == (1 << 1 | 1 << 2) {
            let direction = movableObject.position.x - lastMovableObjectPosition
            let impulseX: CGFloat = direction > 0 ? 20 : (direction < 0 ? -20 : 0)
            contact.bodyA.applyImpulse(CGVector(dx: impulseX, dy: 20))

            updateScore()
        } else if contactMask == (1 << 3 | 1 << 1) || contactMask == (1 << 4 | 1 << 1) {
            handleBonusOrAntiBonus(contact)
        }
    }

    func handleBonusOrAntiBonus(_ contact: SKPhysicsContact) {
        let bonusNode: SKNode? = contact.bodyA.categoryBitMask == (1 << 3) ? contact.bodyA.node : contact.bodyB.node
        
        if let bonusNode = bonusNode {
            if bonusNode.name == "Bonus" && balls.count > 1 {
                removeFallingBall()
                bonusNode.removeFromParent()
            } else if bonusNode.name == "AntiBonus" {
                createFallingBall()
                bonusNode.removeFromParent()
            }
            
        }
        
    }

    func removeFallingBall() {
        if !balls.isEmpty {
            let ballToRemove = balls.removeLast()
            ballToRemove.removeFromParent()
        }
    }

    func startBonusTimer() {
        let wait = SKAction.wait(forDuration: 7.5)
        let createBonusOrAntiBonus = SKAction.run { [weak self] in
            self?.createBonusOrAntiBonus()
        }
        let sequence = SKAction.sequence([wait, createBonusOrAntiBonus])
        run(SKAction.repeatForever(sequence))
    }

    func createBonusOrAntiBonus() {
        let isBonus = Bool.random()
        bonusOrAntiBonus = SKSpriteNode(imageNamed: isBonus ? "Bonus" : "AntiBonus")
        bonusOrAntiBonus.size = CGSize(width: size.width * 0.1, height: size.width * 0.1)
        bonusOrAntiBonus.position = CGPoint(x: CGFloat.random(in: size.width * 0.35...size.width * 0.35), y: size.height * 0.8)
        bonusOrAntiBonus.zPosition = 1
        bonusOrAntiBonus.name = isBonus ? "Bonus" : "AntiBonus"
        
        let physicsBody = SKPhysicsBody(circleOfRadius: bonusOrAntiBonus.size.width / 2)
        physicsBody.restitution = 0.0
        physicsBody.friction = 0.0
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = isBonus ? (1 << 3) : (1 << 4)
        physicsBody.contactTestBitMask = 1 << 1
        bonusOrAntiBonus.physicsBody = physicsBody

        addChild(bonusOrAntiBonus)

        let fallAction = SKAction.moveBy(x: 0, y: -size.height, duration: 10)
        bonusOrAntiBonus.run(fallAction)
    }

    override func update(_ currentTime: TimeInterval) {
        if countdown == 0 && selectedLevel < 7 {
            gameOver()
        } else if selectedLevel > 6 && score >= levelTime {
            gameOver()
        }
        for node in children {
            if (node.name == "Bonus" || node.name == "AntiBonus") && node.position.y < size.height * 0.2 {
                node.removeFromParent()
            }
        }
        checkForGameOver()
    }
    
    func checkForGameOver() {
        for ball in balls {
            if ball.position.y < size.height * 0.18 {
                gameOver()
            }
        }
    }
    

    func gameOver() {
        if isSoundOn {
            let soundAction = SKAction.playSoundFileNamed("gameOverSound.wav", waitForCompletion: false)
            run(soundAction)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.screen?.gameOverSettings(score: self.score, time: self.countdown, level: self.selectedLevel, target: self.levelTime)}
        for ball in balls {
            ball.removeFromParent()
        }
        balls.removeAll()
        removeBonuses()
        
    }
    
    func pauseGame() {
        if !gameIsPaused {
            gameIsPaused = true
            pauseTimers()
            pauseBalls()
            self.view?.isPaused = true
        }
    }
    
    func pauseTimers() {
        removeAction(forKey: "ballTimer")
        removeAction(forKey: "countdownTimer")
    }

    func pauseBalls() {
        for ball in balls {
            ball.physicsBody?.affectedByGravity = false
            ball.physicsBody?.isDynamic = false
            ball.position.y = ball.position.y
        }
    }

    func resumeGame() {
        gameIsPaused = false
        self.view?.isPaused = false
        resumeTimers()
        resumeBalls()
    }

    func resumeTimers() {
        if let ballTimer = ballTimer {
            run(ballTimer)
        }
        if let countdownTimer = countdownTimer {
            run(countdownTimer)
        }
    }
    

    func resumeBalls() {
        for ball in balls {
            ball.physicsBody?.affectedByGravity = true
            ball.physicsBody?.isDynamic = true
        }
    }
    
    func restartGame() {
        for ball in balls {
            ball.removeFromParent()
        }
        balls.removeAll()
        
        score = 0
        scoreLabel.text = "Score: \(score)"
        
        countdown = levelTime
        countdownLabel.text = "\(countdown)"
        
        movableObject.position = CGPoint(x: size.width/2, y: size.height * 0.2)
        lastMovableObjectPosition = movableObject.position.x
        
        removeAllActions()
        removeBonuses()
        
        let delay = SKAction.wait(forDuration: 0.5)
        let startGameAction = SKAction.run { [weak self] in
            self?.createFallingBall()
            self?.startBallTimer()
            self?.startCountdown()
            self?.startBonusTimer()
        }
        
        run(SKAction.sequence([delay, startGameAction]))
        
        gameIsPaused = false
        self.view?.isPaused = false
    }

    func removeBonuses() {
        for node in children {
            if node.name == "Bonus" || node.name == "AntiBonus" {
                node.removeFromParent()
            }
        }
    }



    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let gameField = children.first(where: { $0.name == "GameField" })

        if let gameField = gameField {
            let gameFieldFrame = gameField.frame
            
            if gameFieldFrame.contains(location) {
                movableObject.position.x = max(gameFieldFrame.minX + movableObject.size.width / 2 + 10, min(location.x, gameFieldFrame.maxX - movableObject.size.width / 2 - 10))
                lastMovableObjectPosition = movableObject.position.x
            }
        }
    }
}
