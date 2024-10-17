import UIKit
import SpriteKit
import SnapKit

final class LevelViewController: UIViewController {
    private var imageBG = UIImageView(image: UIImage(named: "DefaultBG"))
  
    private var instructionForGameButton = UIButton(type: .custom)
    private var levelStates: [Bool] = Array(repeating: false, count: 12)
    private var lastCompletedLevel: Int = 0
    private func updateButton() {
        guard let button = view.subviews.first(where: { $0 is UIView && $0.subviews.first is UIButton }) else {
            return
        }

        for index in 0..<levelStates.count {
            if let buttons = button.subviews.first(where: { ($0 as? UIButton)?.tag == index + 1 }) as? UIButton {
                settingsButton(buttons, index: index)
            }
        }
    }

    var onExit: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = SKView(frame: view.frame)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        loadData()
        if levelStates.isEmpty || !levelStates[0] {
            levelStates[0] = true
        }
        createViews()
        addAllButtons()
        
        view.addSubview(exitButton)
        
        exitButton.setImage(UIImage(named: "ExitButton"), for: .normal)
        audioAdd(button: exitButton)
        
        exitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(50)
            make.height.width.equalTo(60)
        }
        
        exitButton.addTarget(self, action: #selector(outController), for: .touchUpInside)
        
        view.addSubview(instructionForGameButton)
        instructionForGameButton.setImage(UIImage(named: "Button"), for: .normal)
        audioAdd(button: instructionForGameButton)
        instructionForGameButton.addTarget(self, action: #selector(instructionButtonTapped), for: .touchUpInside)
        
        instructionForGameButton.snp.makeConstraints { make in
            make.top.equalTo(achiveImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        let instructionLabel = UILabel()
        instructionLabel.text = "INSTRUCTION"
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = .white
        
        instructionLabel.font = UIFont(name: "A25-SQUANOVA", size: 20)
        view.addSubview(instructionLabel)

        instructionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(instructionForGameButton.snp.centerX)
            make.centerY.equalTo(instructionForGameButton.snp.centerY)
        }
    }
    
    @objc private func instructionButtonTapped() {
        let gameViewController = MainMenuGameInstructionController()
        gameViewController.modalTransitionStyle = .crossDissolve
        gameViewController.modalPresentationStyle = .fullScreen
        present(gameViewController, animated: true, completion: nil)
    }
    
    @objc private func outController() {
        dismiss(animated: false)
    }
    
    
    func createViews() {
        imageBG.isUserInteractionEnabled = true
        achiveImage.isUserInteractionEnabled = true
        
        imageBG.contentMode = .scaleAspectFill

        view.addSubview(imageBG)
        view.addSubview(achiveImage)
        
        imageBG.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        achiveImage.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    private var achiveImage = UIImageView(image: UIImage(named: "ElementsBG"))
    private var exitButton = UIButton(type: .custom)
    func addAllButtons() {
        let rows = 3
        let columns = 4
        let buttonSize = 55
        let buttonSpacing = 10

        let totalWidth = (buttonSize * columns) + (buttonSpacing * (columns - 1))
        let totalHeight = (buttonSize * rows) + (buttonSpacing * (rows - 1))

        let buttonsContainer = UIView()
        view.addSubview(buttonsContainer)

        buttonsContainer.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(totalWidth)
            make.height.equalTo(totalHeight)
        }

        for index in 0..<rows * columns {
            let button = UIButton(type: .custom)
            button.tag = index + 1
            audioAdd(button: button)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttonsContainer.addSubview(button)

            let row = index / columns
            let column = index % columns

            button.snp.makeConstraints { make in
                make.width.height.equalTo(buttonSize)

                if column == 0 {
                    make.left.equalTo(buttonsContainer)
                } else {
                    make.left.equalTo(buttonsContainer.subviews[index - 1].snp.right).offset(buttonSpacing)
                }

                if row == 0 {
                    make.top.equalTo(buttonsContainer)
                } else {
                    make.top.equalTo(buttonsContainer.subviews[index - columns].snp.bottom).offset(buttonSpacing + 10)
                }
            }
            
            settingsButton(button, index: index)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "LEVELS"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        
        titleLabel.font = UIFont(name: "A25-SQUANOVA", size: 64)
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(achiveImage.snp.top)
        }
    }

    private func settingsButton(_ button: UIButton, index: Int) {
        let levelIndex = index + 1
        
        if levelStates[index] {
            button.setImage(UIImage(named: "Level"), for: .normal)
            let levelLabel = UILabel()
            levelLabel.text = "\(levelIndex)"
            levelLabel.textColor = .white
            levelLabel.textAlignment = .center
            levelLabel.font = UIFont(name: "A25-SQUANOVA", size: 20)
            button.addSubview(levelLabel)

            levelLabel.snp.makeConstraints { make in
                make.center.equalTo(button)
            }
        } else {
            button.setImage(UIImage(named: "LockLevel"), for: .normal)
            let levelLabel = UILabel()
            levelLabel.text = ""
            levelLabel.textColor = .clear
            levelLabel.textAlignment = .center
            button.addSubview(levelLabel)

            levelLabel.snp.makeConstraints { make in
                make.center.equalTo(button)
            }
        }
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let selectedLevel = sender.tag
        if levelStates[selectedLevel - 1] {
            let gameViewController = MainGameViewControllerForGameScene()
            gameViewController.onExit = {
                self.dismiss(animated: false)
            }
            gameViewController.selectedLevel = selectedLevel
            gameViewController.modalTransitionStyle = .crossDissolve
            gameViewController.modalPresentationStyle = .fullScreen
            present(gameViewController, animated: true, completion: nil)
        }
    }

    func readyLevel(_ level: Int) {
        if level <= levelStates.count {
            levelStates[level - 1] = true
            if level < levelStates.count && !levelStates[level] {
                levelStates[level] = true
            }

            lastCompletedLevel = level
            saveData()
            saveLevelInfo(level)
        }
        updateButton()
    }
    
    private func saveLevelInfo(_ level: Int) {
        let defaults = UserDefaults.standard
        var completedLevels = defaults.array(forKey: "completedLevels") as? [Int] ?? []
        
        if !completedLevels.contains(level) {
            completedLevels.append(level)
            defaults.set(completedLevels, forKey: "completedLevels")
        }
    }

   
    private func saveData() {
        let defaults = UserDefaults.standard
        defaults.set(levelStates, forKey: "levelStates")
        defaults.set(lastCompletedLevel, forKey: "lastCompletedLevel")
    }

    private func loadData() {
        let defaults = UserDefaults.standard

        if let savedLevelStates = defaults.array(forKey: "levelStates") as? [Bool] {
            levelStates = savedLevelStates
        } else {
            levelStates[0] = true
        }

        if let completedLevels = defaults.array(forKey: "completedLevels") as? [Int] {
            for level in completedLevels {
                if level > 0 && level <= levelStates.count {
                    levelStates[level - 1] = true
                }
            }
        }

        lastCompletedLevel = defaults.integer(forKey: "lastCompletedLevel")
    }
}

