import UIKit
import SnapKit
import SafariServices

class MainGameMenuViewController: UIViewController {
    
    let backgroundImageView = UIImageView(image: UIImage(named: "DefaultBG"))
  
    var onExit: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupInterface()
    }
    
    func setupInterface() {
        
        view.addSubview(backgroundImageView)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        view.addSubview(ballImageView)
        ballImageView.contentMode = .scaleAspectFit
        ballImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-50)
            make.width.equalTo(view).multipliedBy(0.9)
            make.height.equalTo(ballImageView.snp.width)
        }
        
        view.addSubview(logoImageView)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(ballImageView.snp.centerY)
            make.width.equalTo(view).multipliedBy(0.9)
        }
        
        view.addSubview(playButton)
        playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
        audioAdd(button: playButton)
        playButton.addTarget(self, action: #selector(gameTap), for: .touchUpInside)
        playButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(ballImageView.snp.bottom).offset(30)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    
    }
    let playButton = UIButton(type: .custom)
    @objc func gameTap() {
        let gameViewController = LevelViewController()
        gameViewController.onExit = { [weak self] in
            self?.dismiss(animated: true)
        }
        gameViewController.modalTransitionStyle = .crossDissolve
        gameViewController.modalPresentationStyle = .fullScreen
        present(gameViewController, animated: true, completion: nil)
    }
    
    let ballImageView = UIImageView(image: UIImage(named: "Ball3"))
    let logoImageView = UIImageView(image: UIImage(named: "Logo"))

}
