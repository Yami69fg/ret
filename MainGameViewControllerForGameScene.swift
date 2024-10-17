import UIKit
import SpriteKit
import GameplayKit

class MainGameViewControllerForGameScene: UIViewController {
    private weak var scene: GameScene?

    let pauseGameButton = UIButton(type: .custom)
    let settingsGameAudioButton = UIButton(type: .custom)
    var selectedLevel: Int = 1
    var targetTime: Int = 0
    var backG: String = ""
    
    let levelInfo: [levelSet] = [
        levelSet(back: "backG1", targetTime: 5),
        levelSet(back: "backG2", targetTime: 10),
        levelSet(back: "backG3", targetTime: 15),
        levelSet(back: "backG1", targetTime: 20),
        levelSet(back: "backG3", targetTime: 25),
        levelSet(back: "backG3", targetTime: 30),
        levelSet(back: "backG1", targetTime: 5),
        levelSet(back: "backG2", targetTime: 10),
        levelSet(back: "backG3", targetTime: 15),
        levelSet(back: "backG2", targetTime: 20),
        levelSet(back: "backG1", targetTime: 25),
        levelSet(back: "backG1", targetTime: 30)
    ]
    
    var onExit: (() -> ())?
    
    override func loadView() {
        self.view = SKView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainButton()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size, level: selectedLevel, backG: levelInfo[selectedLevel-1].back, targetTime: levelInfo[selectedLevel-1].targetTime)
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
                self.scene = scene
                scene.screen = self
                view.ignoresSiblingOrder = true
               
            }
        }

    func setupMainButton() {
        pauseGameButton.setImage(UIImage(named: "PauseButton"), for: .normal)
        pauseGameButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        pauseGameButton.frame = CGRect(x: 20, y: 40, width: 50, height: 50)
        audioAdd(button: pauseGameButton)
        view.addSubview(pauseGameButton)
        
        settingsGameAudioButton.setImage(UIImage(named: "SettingsButton"), for: .normal)
        settingsGameAudioButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        settingsGameAudioButton.frame = CGRect(x: view.frame.width - 70, y: 40, width: 50, height: 50)
        audioAdd(button: settingsGameAudioButton)
        view.addSubview(settingsGameAudioButton)
    }

    @objc func pauseButtonTapped() {
        let settingsVc = MainViewPauseGameController()
        scene?.pauseGame()
        settingsVc.onRetry = { [weak self] in
            self?.scene?.resumeGame()
        }
        settingsVc.modalPresentationStyle = .overFullScreen
        present(settingsVc, animated: false)
    }

    @objc func settingsButtonTapped() {
        let settingsVc = MainViewSettingsController()
        scene?.pauseGame()
        settingsVc.onRetry = { [weak self] in
            self?.scene?.resumeGame()
        }
        settingsVc.onExit = { [weak self] in
            self?.scene?.resumeGame()
            self?.dismiss(animated: true)
        }
        settingsVc.modalPresentationStyle = .overFullScreen
        present(settingsVc, animated: false)
    }
    
    func gameOverSettings(score: Int, time: Int, level: Int, target:Int){
        var gameOver = GameOverMainViewController(img: "TryNow",score: score)
        if time == 0 && level < 7 {
            if UserDefaults.standard.integer(forKey: "lastCompletedLevel") <= selectedLevel {
                let levelController = LevelViewController()
                levelController.readyLevel(selectedLevel)
            }
            gameOver = GameOverMainViewController(img: "YouWin",score: score)
        } else if score >= target && level > 6 {
            if UserDefaults.standard.integer(forKey: "lastCompletedLevel") <= selectedLevel {
                let levelController = LevelViewController()
                levelController.readyLevel(selectedLevel)
            }
            gameOver = GameOverMainViewController(img: "YouWin",score: score)
        }
        scene?.pauseGame()
        gameOver.onRetry = { [weak self] in
            self?.scene?.restartGame()
        }
        gameOver.onExit = { [weak self] in
            self?.scene?.resumeGame()
            self?.dismiss(animated: false) {
                self!.onExit?()
            }
        }
        gameOver.modalPresentationStyle = .overFullScreen
        present(gameOver, animated: false)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

struct levelSet {
    let back: String
    let targetTime: Int
}
