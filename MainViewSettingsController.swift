import UIKit
import SnapKit

class MainViewSettingsController: UIViewController {
    
    var shadowBackgroundImageView: UIImageView!
    var backgroundImageView: UIImageView!
    var settingsImageView: UIImageView!
    var backMenuButton: UIButton!
    var ballImageView: UIImageView!
    
    var vibroToggleButton: UIButton!
    var vibroImageView: UIImageView!
    
    var soundToggleButton: UIButton!
    var soundImageView: UIImageView!
    
    private var topTapAreaView = UIView()
    private var bottomTapAreaView = UIView()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupShadowBackground()
        setupBackground()
        setupBallImage()
        setupSettingsImage()
        setupVibroSection()
        setupSoundSection()
        setupBackButton()
        setupGestureRecognizers()
        
        loadUserPreferences()
        
        view.bringSubviewToFront(topTapAreaView)
        view.bringSubviewToFront(bottomTapAreaView)
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
            make.height.equalTo(view.snp.height).multipliedBy(0.25)
        }

        view.addSubview(topTapAreaView)
        view.addSubview(bottomTapAreaView)
        
        topTapAreaView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(backgroundImageView.snp.top)
        }
        
        bottomTapAreaView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        topTapAreaView.backgroundColor = .clear
        bottomTapAreaView.backgroundColor = .clear
    }

    func setupBallImage() {
        ballImageView = UIImageView()
        ballImageView.image = UIImage(named: "Ball2")
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
        settingsImageView = UIImageView(image: UIImage(named: "Settings"))
        settingsImageView.contentMode = .scaleAspectFit
        view.addSubview(settingsImageView)

        settingsImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
    }

    func setupVibroSection() {
        vibroToggleButton = UIButton(type: .custom)
        audioAdd(button: vibroToggleButton)
        vibroToggleButton.setImage(UIImage(named: isVibroOn ? "On" : "Off"), for: .normal)
        vibroToggleButton.addTarget(self, action: #selector(toggleVibro), for: .touchUpInside)
        view.addSubview(vibroToggleButton)
        
        vibroImageView = UIImageView(image: UIImage(named: "Vibro"))
        vibroImageView.contentMode = .scaleAspectFit
        view.addSubview(vibroImageView)

        vibroToggleButton.snp.makeConstraints { make in
            make.left.equalTo(vibroImageView.snp.right).offset(30)
            make.centerY.equalToSuperview().offset(-30)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }

        vibroImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview().offset(-40)
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
            make.height.equalTo(40)
        }
    }

    func setupSoundSection() {
        soundToggleButton = UIButton(type: .custom)
        audioAdd(button: soundToggleButton)
        soundToggleButton.setImage(UIImage(named: isSoundOn ? "On" : "Off"), for: .normal)
        soundToggleButton.addTarget(self, action: #selector(toggleSound), for: .touchUpInside)
        view.addSubview(soundToggleButton)
        
        soundImageView = UIImageView(image: UIImage(named: "Sound"))
        soundImageView.contentMode = .scaleAspectFit
        view.addSubview(soundImageView)

        soundToggleButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(30)
            make.left.equalTo(soundImageView.snp.right).offset(30)
            make.centerY.equalTo(soundImageView)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }

        soundImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(30)
            make.centerX.equalToSuperview().offset(-40)
            make.top.equalTo(vibroImageView.snp.bottom).offset(10)
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
            make.height.equalTo(40)
        }
    }

    func setupBackButton() {
        backMenuButton = UIButton(type: .custom)
        backMenuButton.setImage(UIImage(named: "BackToMenu"), for: .normal)
        audioAdd(button: backMenuButton)
        backMenuButton.addTarget(self, action: #selector(backToMenuButtonTapped), for: .touchUpInside)
        view.addSubview(backMenuButton)

        backMenuButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(-10)
            make.width.equalTo(view.snp.width).multipliedBy(0.4)
            make.height.equalTo(view.snp.height).multipliedBy(0.04)
        }
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeController))
        topTapAreaView.addGestureRecognizer(tapGesture)
        bottomTapAreaView.addGestureRecognizer(tapGesture)
    }

    @objc func toggleVibro() {
        isVibroOn.toggle()
        vibroToggleButton.setImage(UIImage(named: isVibroOn ? "On" : "Off"), for: .normal)
    }

    @objc func toggleSound() {
        isSoundOn.toggle()
        soundToggleButton.setImage(UIImage(named: isSoundOn ? "On" : "Off"), for: .normal)
    }

    @objc func closeController() {
        onRetry?()
        dismiss(animated: true, completion: nil)
    }

    @objc func backToMenuButtonTapped() {
        dismiss(animated: false)
        onExit?()
    }
    
    private func loadUserPreferences() {
        vibroToggleButton.setImage(UIImage(named: isVibroOn ? "On" : "Off"), for: .normal)
        soundToggleButton.setImage(UIImage(named: isSoundOn ? "On" : "Off"), for: .normal)
    }
}
