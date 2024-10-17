import UIKit
import SnapKit

class LoadingGameViewController: UIViewController {
    
    let backgroundImageView = UIImageView(image: UIImage(named: "DefaultBG"))
    let ballImageView = UIImageView(image: UIImage(named: "Ball3"))
    let loadingImageView = UIImageView(image: UIImage(named: "Loading"))
    
    var ballTopConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupInterface()
        startBallJumping()
        startLoadingImageAnimation()
        transitionToMainMenu()
    }
    
    func setupInterface() {
        view.addSubview(backgroundImageView)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        view.addSubview(loadingImageView)
        loadingImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(100)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        view.addSubview(ballImageView)
        ballImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(loadingImageView.snp.top).offset(-20)
            make.width.height.equalTo(100)
        }
    }
    
    func startBallJumping() {
        let jumpHeight: CGFloat = 100
        let jumpDuration: TimeInterval = 0.5
        
        UIView.animate(withDuration: jumpDuration,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseInOut],
                       animations: {
                           self.ballImageView.transform = CGAffineTransform(translationX: 0, y: -jumpHeight)
                       },
                       completion: nil)
    }
    
    func startLoadingImageAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            UIView.animate(withDuration: 0.5) {
                self.loadingImageView.alpha = self.loadingImageView.alpha == 1.0 ? 0.0 : 1.0
            }
        }
    }
    
    func transitionToMainMenu() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let mainMenuVC = MainGameMenuViewController()
            mainMenuVC.modalTransitionStyle = .crossDissolve
            mainMenuVC.modalPresentationStyle = .fullScreen
            self.present(mainMenuVC, animated: true, completion: nil)
        }
    }
}
