import UIKit

//MARK: - class
class SettingsViewController: UIViewController {
    
    // MARK: - lets/vars
    var settings: Settings?
    
    var fishObstacles: Bool = false
    var torpedosObstacles: Bool = false
    var shipsObstacles: Bool = false
    
    var submarineSkinIndex = 1
    var gameSpeed = 1 {
        didSet {
            self.speedGameLabel.text = String("\(self.gameSpeed)")
        }
    }
    
    // MARK: IBoutlets
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var fishSwitch: UISwitch!
    @IBOutlet weak var torpedaSwitch: UISwitch!
    @IBOutlet weak var shipsSwitch: UISwitch!
    
    @IBOutlet weak var speedGameLabel: UILabel!
    
    @IBOutlet weak var yellowSubmarine: UIButton!
    @IBOutlet weak var blueSubmarine: UIButton!
    @IBOutlet weak var redSubmarine: UIButton!
    @IBOutlet weak var greenSubmarine: UIButton!
    
    @IBOutlet weak var obstaclesLabel: UILabel!
    @IBOutlet weak var chooseSubLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var gameSpeedLabel: UILabel!
    @IBOutlet weak var yellowlabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var fishLabel: UILabel!
    @IBOutlet weak var torpedaLabel: UILabel!
    @IBOutlet weak var shipLabel: UILabel!
    
    @IBOutlet weak var crashButton: UIButton!
        
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        self.view.addGestureRecognizer(recognizer)
        self.setupSubmarineButtons()
        self.fishObstacles = false
        if UserDefaults.standard.value(forKey: "settings") == nil {
            debugPrint("I haven't got settings - load default settngs")
            self.setDefaultSettings()
        } else {
            debugPrint("I have got settings")
            self.loadSettings()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.localize()
    }
    
    // MARK: - @IBAction
    @IBAction func crashButtonPressed(_ sender: UIButton) {
        let numbers = [0]
        let _ = numbers[1]
    }
    
    @IBAction func tapDetected(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        self.gameSpeed = Int(sender.value)
    }
    
    @IBAction func mainButtonPressed(_ sender: UIButton) {
        saveSettings()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func fishSwitch(_ sender: UISwitch) {
        if sender.isOn {
            debugPrint("ON")
            self.fishObstacles = true
        } else {
            debugPrint("OFF")
            self.fishObstacles = false
        }
    }
    
    @IBAction func torpedosSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.torpedosObstacles = true
        } else {
            self.torpedosObstacles = false
        }
    }
    
    @IBAction func shipsSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.shipsObstacles = true
        } else {
            self.shipsObstacles = false
        }
    }
    
    @IBAction func chooseYellowSubmarine(_ sender: UIButton) {
        self.yellowSubmarine.isSelected = true
        self.blueSubmarine.isSelected = false
        self.redSubmarine.isSelected = false
        self.greenSubmarine.isSelected = false
        self.submarineSkinIndex = 1
    }
    
    @IBAction func chooseBlueSubmarine(_ sender: UIButton) {
        self.yellowSubmarine.isSelected = false
        self.blueSubmarine.isSelected = true
        self.redSubmarine.isSelected = false
        self.greenSubmarine.isSelected = false
        self.submarineSkinIndex = 2
    }
    
    @IBAction func chooseRedubmarine(_ sender: UIButton) {
        self.yellowSubmarine.isSelected = false
        self.blueSubmarine.isSelected = false
        self.redSubmarine.isSelected = true
        self.greenSubmarine.isSelected = false
        self.submarineSkinIndex = 3
    }
    
    @IBAction func chooseGreenSubmarine(_ sender: UIButton) {
        self.yellowSubmarine.isSelected = false
        self.blueSubmarine.isSelected = false
        self.redSubmarine.isSelected = false
        self.greenSubmarine.isSelected = true
        self.submarineSkinIndex = 4
    }
    
    // MARK: - flow funcs
    func setupSubmarineButtons() {
        self.yellowSubmarine.isSelected = false
        self.blueSubmarine.isSelected = false
        self.redSubmarine.isSelected = false
        self.greenSubmarine.isSelected = false
    }
    
    func saveSettings() {
        guard let name = nameTextField.text else { return }
        let settings = Settings(submarine: submarineSkinIndex, speed: gameSpeed, name: name, fish: fishObstacles, torpeda: torpedosObstacles , ship: shipsObstacles)
        UserDefaults.standard.set(encodable: settings, forKey: "settings")
    }
    
    func getSettings() {
        guard let defaults = UserDefaults.standard.value(Settings.self, forKey: "settings") else { return }
        settings = defaults
    }
    
    func loadSettings() {
        guard let settings = UserDefaults.standard.value(Settings.self, forKey: "settings") else { return }
        self.nameTextField.text = settings.name
        self.gameSpeed = settings.speed
        self.fishObstacles = settings.fish
        self.torpedosObstacles = settings.torpeda
        self.shipsObstacles = settings.ship
        self.fishSwitch.isOn = settings.fish
        self.torpedaSwitch.isOn = settings.torpeda
        self.shipsSwitch.isOn = settings.ship
        self.submarineSkinIndex = settings.submarine
        switch self.submarineSkinIndex {
        case 1:
            self.yellowSubmarine.isSelected = true
        case 2:
            self.blueSubmarine.isSelected = true
        case 3:
            self.redSubmarine.isSelected = true
        case 4:
            self.greenSubmarine.isSelected = true
        default:
            self.yellowSubmarine.isSelected = true
        }
    }
    
    func setDefaultSettings() {
        let settings = Settings(submarine: 1, speed: 1, name: "User", fish: true, torpeda: true, ship: true)
        self.nameTextField.text = settings.name
        self.gameSpeed = settings.speed
        self.fishObstacles = settings.fish
        self.torpedosObstacles = settings.torpeda
        self.shipsObstacles = settings.ship
        self.fishSwitch.isOn = settings.fish
        self.torpedaSwitch.isOn = settings.torpeda
        self.shipsSwitch.isOn = settings.ship
        self.submarineSkinIndex = settings.submarine
        switch self.submarineSkinIndex {
        case 1:
            self.yellowSubmarine.isSelected = true
        case 2:
            self.blueSubmarine.isSelected = true
        case 3:
            self.redSubmarine.isSelected = true
        case 4:
            self.greenSubmarine.isSelected = true
        default:
            self.yellowSubmarine.isSelected = true
        }
    }
    
    func localize() {
        let backButton = "Back".localized
        self.backButton.setTitle(backButton,
                                 for: .normal)
        
        let welcomeLabel = "Welcome Lable".localized
        self.welcomeLabel.text = welcomeLabel
        
        let userName = "User Name".localized
        self.userNameLabel.text = userName
        
        let chooseSubLabel = "Choose Sub".localized
        self.chooseSubLabel.text = chooseSubLabel
        
        let obstacles = "Obstacles".localized
        self.obstaclesLabel.text = obstacles
        
        let yellow = "Yellow".localized
        self.yellowlabel.text = yellow
        
        let blue = "Blue".localized
        self.blueLabel.text = blue
        
        let red = "Red".localized
        self.redLabel.text = red
        
        let green = "Green".localized
        self.greenLabel.text = green
        
        let fish = "Fish".localized
        self.fishLabel.text = fish
        
        let torpedos = "Torpedos".localized
        self.torpedaLabel.text = torpedos
        
        let ship = "Ship".localized
        self.shipLabel.text = ship
        
        let gameSpeed = "Game Speed".localized
        self.gameSpeedLabel.text = gameSpeed
    }

}

// MARK: - extension
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
