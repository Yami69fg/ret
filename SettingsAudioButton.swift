import UIKit
import SpriteKit
import AVFoundation

extension UIViewController {
    func audioAdd(button: UIButton) {
        button.addTarget(self, action: #selector(down(sender: )), for: .touchDown)
    }
    
    @objc private func down(sender: UIButton) {
        AudioManager.shared.audioAdd()
        sender.transform = CGAffineTransformMakeScale(0.95, 0.95)
    }
}

class AudioManager {
    
    static let shared = AudioManager()
    private var player: AVAudioPlayer?

    private init() {}
    
    func vibration() {
        let isVibroOn = UserDefaults.standard.bool(forKey: "isVibroOn")
        if isVibroOn {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    func sound() {
        let isSoundOn = UserDefaults.standard.bool(forKey: "isSoundOn")
        if isSoundOn {
            guard let url = Bundle.main.url(forResource: "tapButton", withExtension: "wav") else { return }
            player = try? AVAudioPlayer(contentsOf: url)
            player?.play()
        }
    }
    
    func audioAdd() {
        sound()
        vibration()
    }
}

