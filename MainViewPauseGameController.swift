import UIKit
import SnapKit

class MainViewPauseGameController: UIViewController {
    
    var shadowBackgroundImageView: UIImageView!
    var backgroundImageView: UIImageView!
    var pauseImageView: UIImageView!
    var backMenuButton: UIButton!
    var ballImageView: UIImageView!
    
    var onRetry: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupShadowBackground()
        setupBackground()
        setupBallImage()
        setupPauseImage()
        setupBackButton()
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
            make.height.equalTo(view.snp.height).multipliedBy(0.15)
        }
    }
    
    func setupBallImage() {
        ballImageView = UIImageView()
        ballImageView.image = UIImage(named: "Ball1")
        ballImageView.contentMode = .scaleAspectFit
        view.addSubview(ballImageView)

        ballImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backgroundImageView.snp.top).offset(20)
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
            make.height.equalTo(ballImageView.snp.width)
        }
    }

    func setupPauseImage() {
        pauseImageView = UIImageView(image: UIImage(named: "Pause"))
        pauseImageView.contentMode = .scaleAspectFit
        view.addSubview(pauseImageView)

        pauseImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backgroundImageView.snp.top).offset(-100)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
    }

    func setupBackButton() {
        backMenuButton = UIButton(type: .custom)
        backMenuButton.setImage(UIImage(named: "BackButton"), for: .normal)
        backMenuButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        audioAdd(button: backMenuButton)
        view.addSubview(backMenuButton)

        backMenuButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(-10)
            make.width.equalTo(view.snp.width).multipliedBy(0.4)
            make.height.equalTo(view.snp.height).multipliedBy(0.04)
        }
    }

    @objc func backButtonTapped() {
        onRetry?()
        dismiss(animated: false)
    }
}
