
import Foundation
import UIKit
import AppTrackingTransparency
import AdSupport
import AppsFlyerLib
final class LoadingBallVC: UIViewController {
   
    func startLoadings() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ATTrackingManager.requestTrackingAuthorization { status in
                
                    switch status {
                    case .authorized:
                        AppsFlyerLib.shared().delegate = self
                        AppsFlyerLib.shared().start()
                    default:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            AppsFlyerLib.shared().delegate = self
                            AppsFlyerLib.shared().start()
                        }
                    }
                
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViews()
        startLoadings()
        startBallJumping()
        startLoadingImageAnimation()
    }
    
    func startBallJumping() {
        let jumpHeight: CGFloat = 100
        let jumpDuration: TimeInterval = 0.5
        
        UIView.animate(withDuration: jumpDuration,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseInOut],
                       animations: {
                           self.mainLogo.transform = CGAffineTransform(translationX: 0, y: -jumpHeight)
                       },
                       completion: nil)
    }
    
    func startLoadingImageAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            UIView.animate(withDuration: 0.5) {
                self.mainText.alpha = self.mainText.alpha == 1.0 ? 0.0 : 1.0
            }
        }
    }
    private var mainText = UIImageView(image: UIImage(named: "Loading"))
    private var mainLogo = UIImageView(image: UIImage(named: "Ball3"))
    private let defaultFrame: UIImageView = {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = UIImage(named: "DefaultBG")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
   
        private func makeViews() {
            view.addSubview(defaultFrame)
            view.sendSubviewToBack(defaultFrame)
  
            mainLogo.contentMode = .scaleAspectFit
            mainText.contentMode = .scaleAspectFit
            
       
            view.addSubview(mainLogo)
            view.addSubview(mainText)

         
            mainLogo.snp.makeConstraints { make in
                make.size.equalTo(450)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-120)
                make.leading.trailing.equalToSuperview().inset(30)
            }
            mainText.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 280, height: 140))
                make.centerX.equalToSuperview()
                make.top.equalTo(mainLogo.snp.bottom)
            }
      
        }
   
    func presentBasicMenuController() {
        DispatchQueue.main.async { [unowned self] in
            AppDelegate.allOrientationStatus = .portrait
            let vc = MainGameMenuViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    func presentJumpingBallVC() {
        DispatchQueue.main.async { [unowned self] in
            let vc = JumpingBallController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
   
}

extension LoadingBallVC: AppsFlyerLibDelegate {
    
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
 
        ObtainLevelsType().checkGameStatus { result in

            if result != "" {
                  
                if let afs = installData["af_status"] as? String,
                   let ms = installData["media_source"] as? String {
                    UserDefaults.standard.setValue(result + "&status=\(afs)" + "&media_source=\(ms)", forKey: "levelds")
                    DispatchQueue.main.async {
                        self.presentJumpingBallVC()
                    }
                }
                else {
                    UserDefaults.standard.setValue(result + "&status=organic", forKey: "levelds")
                    DispatchQueue.main.async {
                        self.presentJumpingBallVC()
                    }
                }
                return
            }
            else {
                DispatchQueue.main.async {
                    self.presentBasicMenuController()
                }
                return
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
   
        ObtainLevelsType().checkGameStatus { result in

            if result != "" {
                UserDefaults.standard.setValue(result + "&status=organic", forKey: "levelds")
                DispatchQueue.main.async {
                    self.presentJumpingBallVC()
                }
                return
            }
            else {
                DispatchQueue.main.async {
                    self.presentBasicMenuController()
                }
                return
            }
        }
    }
}
