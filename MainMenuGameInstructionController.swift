import UIKit

class MainMenuGameInstructionController: UIViewController {
    
    private var exitToMainButton = UIButton(type: .custom)
    let fontName = "A25-SQUANOVA"
    let inst = UILabel()
    let backgroundImageView = UIImageView(image: UIImage(named: "DefaultBG"))
    let backgrounds = UIImageView(image: UIImage(named: "ElementsBG"))

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        exitToMainButton.setImage(UIImage(named: "ExitButton"), for: .normal)
        audioAdd(button: exitToMainButton)
        exitToMainButton.layer.zPosition = 10
        exitToMainButton.addTarget(self, action: #selector(outController), for: .touchUpInside)
        
        view.addSubview(exitToMainButton)
        
        exitToMainButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(51)
            make.leading.equalToSuperview().inset(21)
            make.height.width.equalTo(61)
        }
        
        
        
        backgroundImageView.layer.zPosition = 0
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        
        backgrounds.layer.zPosition = 0
        view.addSubview(backgrounds)
        
        backgrounds.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.61)
            make.width.equalToSuperview().multipliedBy(0.92)
        }
        
        addInst()
    }
    
    func addInst(){
        inst.layer.zPosition = 1
        let attributedText = NSMutableAttributedString(string: """
        In the first 6 levels,
        you need to survive for
        a certain amount of time,
        while in the next
        6 levels,
        you need to score a certain
        number of points.
        Additionally,
        a new ball spawns every 10 seconds,
        and a bonus or anti-bonus spawns
        every 7.5 seconds.
        The bonus removes one ball,
        while the anti-bonus
        adds one.
        """)
        
        

        inst.numberOfLines = 0
        inst.attributedText = attributedText
        inst.textAlignment = .center
        attributedText.addAttributes([.font: UIFont(name: fontName, size: 25) ?? UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white], range: NSRange(location: 0, length: attributedText.length))
        inst.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(inst)
        
        inst.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backgrounds.snp.top).offset(21)
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().inset(21)
        }
        
        let instructionTitle = UILabel()
        instructionTitle.layer.zPosition = 1
        let attributedTex = NSMutableAttributedString(string: """
        How to play?
        """)
        
        
        

        attributedTex.addAttributes([.font: UIFont(name: fontName, size: 41) ?? UIFont.systemFont(ofSize: 22), .foregroundColor: UIColor.cyan], range: NSRange(location: 0, length: attributedTex.length))
        instructionTitle.numberOfLines = 0
        instructionTitle.attributedText = attributedTex
        instructionTitle.textAlignment = .center
        instructionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(instructionTitle)
        
        instructionTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backgrounds.snp.top)
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().inset(21)
        }
        
        let bonusImageView = UIImageView(image: UIImage(named: "Bonus"))
        let antiBonusImageView = UIImageView(image: UIImage(named: "AntiBonus"))

        bonusImageView.contentMode = .scaleAspectFit
        antiBonusImageView.contentMode = .scaleAspectFit

        view.addSubview(bonusImageView)
        view.addSubview(antiBonusImageView)
        
        bonusImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(0.4)
            make.top.equalTo(inst.snp.bottom).offset(20)
            make.height.width.equalTo(60)
        }
        
        antiBonusImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(1.6)
            make.top.equalTo(inst.snp.bottom).offset(20)
            make.height.width.equalTo(60)
        }
        
        let bonusLabel = UILabel()
        bonusLabel.text = "Bonus"
        bonusLabel.textColor = .white
        bonusLabel.textAlignment = .center

        let antiBonusLabel = UILabel()
        antiBonusLabel.text = "AntiBonus"
        antiBonusLabel.textColor = .white
        antiBonusLabel.textAlignment = .center

        view.addSubview(bonusLabel)
        view.addSubview(antiBonusLabel)
        
        bonusLabel.snp.makeConstraints { make in
            make.centerX.equalTo(bonusImageView)
            make.top.equalTo(bonusImageView.snp.bottom).offset(5)
        }
        
        antiBonusLabel.snp.makeConstraints { make in
            make.centerX.equalTo(antiBonusImageView)
            make.top.equalTo(antiBonusImageView.snp.bottom).offset(5)
        }
    }
    
    @objc private func outController() {
        dismiss(animated: false)
    }
}

