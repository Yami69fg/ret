import UIKit
import SnapKit

class GameOverMainViewController: UIViewController {
    private var titleImage: String
    
    var shadowBackgroundImageView: UIImageView!
    var backgroundImageView: UIImageView!
    var settingsImageView: UIImageView!
    var backMenuButton: UIButton!
    var againGameButton: UIButton!
    var ballImageView: UIImageView!
    
    var scoreBackgroundImageView: UIImageView!
    var scoreLabel: UILabel!
    var bestScoreLabel: UILabel!
    
    var score = 0
    
    var onRetry: (() -> ())?
    var onExit: (() -> ())?
    
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
    
    init(img: String,score:Int) {
        self.titleImage = img
        self.score = score
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupShadowBackground()
        setupBackground()
        setupBallImage()
        setupSettingsImage()
        setupBackButton()
        setupAgainButton()
        setupScoreBackground()
        setupScoreLabel()
        setupBestScoreLabel()
    }
    
    func setupShadowBackground() {
        shadowBackgroundImageView = UIImageView()
        shadowBackgroundImageView.image = UIImage(named: "Shadow")
        shadowBackgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(shadowBackgroundImageView)

        shadowBackgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupBackground() {
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "ElementsBG")
        view.addSubview(backgroundImageView)

        backgroundImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }
    }

    func setupBallImage() {
        ballImageView = UIImageView()
        ballImageView.image = UIImage(named: "Ball3")
        ballImageView.contentMode = .scaleAspectFit
        view.addSubview(ballImageView)

        ballImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backgroundImageView.snp.top).offset(20)
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
            make.height.equalTo(ballImageView.snp.width)
        }
    }

    func setupSettingsImage() {
        settingsImageView = UIImageView(image: UIImage(named: titleImage))
        settingsImageView.contentMode = .scaleAspectFit
        view.addSubview(settingsImageView)

        settingsImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
    }

    func setupBackButton() {
        backMenuButton = UIButton(type: .custom)
        backMenuButton.setImage(UIImage(named: "BackToMenu"), for: .normal)
        backMenuButton.addTarget(self, action: #selector(backToMenuButtonTapped), for: .touchUpInside)
        audioAdd(button: backMenuButton)
        view.addSubview(backMenuButton)

        backMenuButton.snp.makeConstraints { make in
            make.right.equalTo(backgroundImageView.snp.right).offset(10)
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(10)
            make.width.equalTo(view.snp.width).multipliedBy(0.35)
            make.height.equalTo(view.snp.height).multipliedBy(0.04)
        }
    }

    func setupAgainButton() {
        againGameButton = UIButton(type: .custom)
        againGameButton.setImage(UIImage(named: "AgainButton"), for: .normal)
        againGameButton.addTarget(self, action: #selector(closeController), for: .touchUpInside)
        audioAdd(button: againGameButton)
        view.addSubview(againGameButton)

        againGameButton.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView.snp.left).offset(-10)
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(10)
            make.width.equalTo(view.snp.width).multipliedBy(0.35)
            make.height.equalTo(view.snp.height).multipliedBy(0.04)
        }
    }

    func setupScoreBackground() {
        scoreBackgroundImageView = UIImageView(image: UIImage(named: "ScoreBG"))
        scoreBackgroundImageView.contentMode = .scaleAspectFit
        view.addSubview(scoreBackgroundImageView)

        scoreBackgroundImageView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundImageView.snp.centerX)
            make.centerY.equalTo(backgroundImageView.snp.centerY).offset(100)
            make.width.equalTo(backgroundImageView.snp.width).multipliedBy(0.8)
            make.height.equalTo(scoreBackgroundImageView.snp.width).multipliedBy(0.5)
        }
    }

    func setupScoreLabel() {
        scoreLabel = UILabel()
        scoreLabel.text = "Score: \(score)"
        scoreLabel.font = UIFont(name: "A25-SQUANOVA", size: 20)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        view.addSubview(scoreLabel)

        scoreLabel.snp.makeConstraints { make in
            make.left.equalTo(scoreBackgroundImageView.snp.left).offset(20)
            make.centerY.equalTo(scoreBackgroundImageView.snp.centerY)
        }
    }

    func setupBestScoreLabel() {
        bestScoreLabel = UILabel()
        let bestScore = UserDefaults.standard.integer(forKey: "BestScore")
        bestScoreLabel.text = "Best: \(bestScore)"
        bestScoreLabel.font = UIFont(name: "A25-SQUANOVA", size: 20)
        bestScoreLabel.textColor = .white
        bestScoreLabel.textAlignment = .center
        view.addSubview(bestScoreLabel)

        bestScoreLabel.snp.makeConstraints { make in
            make.right.equalTo(scoreBackgroundImageView.snp.right).offset(-20)
            make.centerY.equalTo(scoreBackgroundImageView.snp.centerY)
        }
    }

    @objc func closeController() {
        onRetry?()
        dismiss(animated: true, completion: nil)
    }

    @objc func backToMenuButtonTapped() {
        dismiss(animated: false)
        onExit?()
    }
}
