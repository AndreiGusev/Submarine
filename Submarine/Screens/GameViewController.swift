import UIKit
import CoreMotion

//MARK: - class
class GameViewController: UIViewController {
    
    // MARK: - lets/vars
    var coreMotionManager = CMMotionManager()
    var ship: UIImageView?
    var coin: UIImageView?
    var torpeda: UIImageView?
    var medKit: UIImageView?
    var fish: UIImageView?
    var score = 0 {
        didSet {
            self.scoreLabelInt.text = String(self.score)
        }
    }
    
    var userName = ""
    var speedGame = 1
    var timeForAnimationObstacles = 0.3
    var timeForAnimationCoinAndHealth = 0.3
    let date = Date()
    
    var timerForCoin = Timer()
    var timerForShip = Timer()
    var timerForFish = Timer()
    var timerForTorpeda = Timer()
    var timerForMedkit = Timer()
    
    // MARK: IBoutlets
    @IBOutlet weak var mySubmarineView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreLabelInt: UILabel!
    @IBOutlet weak var skyView: UIView!
    @IBOutlet weak var seaView: UIView!
    @IBOutlet weak var sandView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var hpBar: UIProgressView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playerName: UILabel!
    
    // MARK: - lifecycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        getSettings()
        emergencyMoveUp()
        moveSubWithCoreMotion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGameDifficulty()
        coinTimer()
        medKitTimer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.localize()
    }
    
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.stopAllTimers()
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didUpButtonTap(_ sender: Any) {
        goUp()
    }
    
    @IBAction func didDownButtonTap(_ sender: Any) {
        goDown()
    }
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {return}
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - flow funcs
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
       print(motion)
       if motion == .motionShake {
           debugPrint("shake was detected")
       }
    }
    
    func emergencyMoveUp() {
        if coreMotionManager.isGyroAvailable {
            coreMotionManager.startGyroUpdates(to: .main) { [weak self] data, error in
                if let gyro = data?.rotationRate {
                    if gyro.y >= 1.2 && gyro.z >= 1 {
                        
                        debugPrint("shake was detected by manual")
                        
                        self?.coreMotionManager.stopGyroUpdates()
                        UIView.animate(withDuration: 0.1) {
                            self?.mySubmarineView.frame.origin.y = (self?.skyView.frame.minY)!
                        }
                    }
                }
            }
        }
    }
    
    func moveSubWithCoreMotion() {
        if coreMotionManager.isAccelerometerAvailable {
            coreMotionManager.accelerometerUpdateInterval = 0.1
            coreMotionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                if let acceleration = data?.acceleration {
                    if acceleration.y >= -0.8 && acceleration.y <= -0.15 {
                        self?.goUp()
                    }
                    
                    if acceleration.y <= 0.8 && acceleration.y >= 0.15 {
                        self?.goDown()
                    }
                    debugPrint("y:  \(acceleration.y)")
                }
            }
        }
    }
    
    func goUp() {
        if self.mySubmarineView.frame.origin.y <= self.seaView.frame.minY - self.mySubmarineView.frame.origin.y {
            self.gameEnd()
        }
        UIView.animate(withDuration: 0.1) {
            self.mySubmarineView.frame.origin.y -= 15
            self.hpBar.frame.origin.y -= 15
        }
    }
    
    func goDown() {
        if self.mySubmarineView.frame.origin.y >= self.seaView.frame.maxY - self.mySubmarineView.frame.origin.y / 6 {
            self.gameEnd()
        }
        UIView.animate(withDuration: 0.1) {
            self.mySubmarineView.frame.origin.y += 15
            self.hpBar.frame.origin.y += 15
        }
    }
    
    // MARK: - coin
    func coinTimer() {
        timerForCoin = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            self.newCoin()
            self.coinMove()
        }
    }
    
    func newCoin() {
        let coinWidth:CGFloat = 30
        let coinHeight:CGFloat = 30
        let yPosition = CGFloat.random(in: (self.seaView.frame.minY + coinHeight)...(self.seaView.frame.maxY - coinHeight))
        let newCoin = UIImageView(image: UIImage(named: "coin"))
        newCoin.frame = CGRect(x: self.view.frame.maxX, y: yPosition, width: coinWidth, height: coinHeight)
        coin = newCoin
        self.view.addSubview(newCoin)
    }
    
    func coinMove() {
        guard let submarine = self.mySubmarineView,
              let coin = self.coin else { return }
        let timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { timer in
            if let coinFrame = coin.layer.presentation()?.frame,
               let submarineFrame = submarine.layer.presentation()?.frame {
                if coinFrame.intersects(submarineFrame) {
                    coin.removeFromSuperview()
                    self.score += 1
                }
            }
        }
        UIView.animate(withDuration: self.timeForAnimationCoinAndHealth, delay: 0, options: .curveLinear) {
            coin.frame.origin.x = self.view.frame.minX - coin.frame.width
        } completion: { _ in
            coin.removeFromSuperview()
        }
    }
    
    // MARK: - torpeda
    func torpedaTimer() {
        timerForTorpeda = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { timer in
            self.newTorpeda()
            self.torpedaMove()
        }
    }
    
    func newTorpeda(){
        let torpedaWidth:CGFloat = 70
        let torpedaHeight:CGFloat = 30
        let yPosition = CGFloat.random(in: (self.seaView.frame.minY + torpedaHeight)...(self.seaView.frame.maxY - torpedaHeight))
        let newTorpeda = UIImageView(image: UIImage(named: "torpeda"))
        newTorpeda.frame = CGRect(x: self.view.frame.maxX, y: yPosition, width: torpedaWidth, height: torpedaHeight)
        torpeda = newTorpeda
        self.view.addSubview(newTorpeda)
    }
    
    func torpedaMove() {
        guard let submarine = self.mySubmarineView,
              let torpeda  = self.torpeda else { return }
        let timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { timer in
            if let torpedaFrame = torpeda.layer.presentation()?.frame,
               let submarineFrame = submarine.layer.presentation()?.frame {
                if torpedaFrame.intersects(submarineFrame) {
                    torpeda.removeFromSuperview()
                    self.hpBar.progress -= 0.5
                    timer.invalidate()
                    if self.hpBar.progress == 0 {
                        self.gameEnd()
                    } else {
                    }
                }
            }
        }
        UIView.animate(withDuration: self.timeForAnimationObstacles, delay: 0, options: .curveLinear) {
            torpeda.frame.origin.x = self.seaView.frame.minX - torpeda.frame.width
        } completion: { _ in
            torpeda.removeFromSuperview()
        }
    }
    
    
    // MARK: - medKit
    func medKitTimer() {
        timerForMedkit = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            self.newMedKit()
            self.medKitMove()
        }
    }
    
    func newMedKit() {
        let medKitWidth:CGFloat = 40
        let medKitHeight:CGFloat = 40
        let yPosition = CGFloat.random(in: (self.seaView.frame.minY + medKitHeight)...(self.seaView.frame.maxY - medKitHeight))
        let newMedKit = UIImageView(image: UIImage(named: "medKit"))
        newMedKit.frame = CGRect(x: self.seaView.frame.maxX, y: yPosition, width: medKitWidth, height: medKitWidth)
        medKit = newMedKit
        self.view.addSubview(newMedKit)
    }
    
    func medKitMove() {
        guard let submarine = self.mySubmarineView,
              let medKit  = self.medKit else {return}
        let timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { timer in
            if let medKitFrame = medKit.layer.presentation()?.frame,
               let submarineFrame = submarine.layer.presentation()?.frame {
                if medKitFrame.intersects(submarineFrame) {
                    self.hpBar.progress += 0.25
                    medKit.removeFromSuperview()
                }
            }
        }
        
        UIView.animate(withDuration: self.timeForAnimationCoinAndHealth, delay: 0, options: .curveLinear) {
            medKit.frame.origin.x = self.seaView.frame.minX - medKit.frame.width
        } completion: { _ in
            medKit.removeFromSuperview()
        }
    }
    
    // MARK: - fish
    func fishTimer() {
        timerForFish = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { timer in
            self.newFish()
            self.fishMove()
        }
    }
    
    func newFish() {
        let fishWidth:CGFloat = 35
        let fishHeight:CGFloat = 35
        let yPosition = CGFloat.random(in: (self.seaView.frame.minY + fishHeight)...(self.seaView.frame.maxY - fishHeight))
        let newFish = UIImageView(image: UIImage(named: "fish"))
        newFish.frame = CGRect(x: self.seaView.frame.maxX, y: yPosition, width: fishWidth, height: fishWidth)
        fish = newFish
        self.view.addSubview(newFish)
    }
    
    func fishMove() {
        guard let submarine = self.mySubmarineView,
              let fish  = self.fish else {return}
        let timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { timer in
            if let fishFrame = fish.layer.presentation()?.frame,
               let submarineFrame = submarine.layer.presentation()?.frame {
                if fishFrame.intersects(submarineFrame) {
                    fish.removeFromSuperview()
                    self.hpBar.progress -= 0.5
                    timer.invalidate()
                    if self.hpBar.progress == 0 {
                        self.gameEnd()
                    } else {
                    }
                }
            }
        }
        UIView.animate(withDuration: self.timeForAnimationObstacles, delay: 0, options: .curveLinear) {
            fish.frame.origin.x = self.seaView.frame.minX - fish.frame.width
        } completion: { _ in
            fish.removeFromSuperview()
        }
    }
    
    
    // MARK: - ship
    func shipTimer() {
        timerForShip = Timer.scheduledTimer(withTimeInterval: 4.5, repeats: true) { timer in
            self.newShip()
            self.shipMove()
        }
    }
    
    func newShip() {
        let shipWidth:CGFloat = 60
        let shipHeight:CGFloat = 35
        let yPosition = self.seaView.frame.minY - shipHeight
        let newShip = UIImageView(image: UIImage(named: "ship"))
        newShip.frame = CGRect(x: self.seaView.frame.maxX, y: yPosition, width: shipWidth, height: shipWidth)
        ship = newShip
        self.view.addSubview(newShip)
    }
    
    func shipMove() {
        guard let submarine = self.mySubmarineView,
              let ship  = self.ship else {return}
        let timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { timer in
            if let shipFrame = ship.layer.presentation()?.frame,
               let submarineFrame = submarine.layer.presentation()?.frame {
                if shipFrame.intersects(submarineFrame) {
                    ship.removeFromSuperview()
                    self.hpBar.progress -= 0.5
                    timer.invalidate()
                    if self.hpBar.progress == 0 {
                        self.gameEnd()
                    } else {
                    }
                }
            }
        }
        UIView.animate(withDuration: self.timeForAnimationObstacles, delay: 0, options: .curveLinear) {
            ship.frame.origin.x = self.seaView.frame.minX - ship.frame.width
        } completion: { _ in
            ship.removeFromSuperview()
        }
    }
    
    func stopAllTimers() {
        self.timerForShip.invalidate()
        self.timerForFish.invalidate()
        self.timerForMedkit.invalidate()
        self.timerForCoin.invalidate()
        self.timerForTorpeda.invalidate()
    }
    
    func getCurrentDate() -> String {
        let currentDate = Date()
        let format = DateFormatter()
        format.dateFormat = "HH:mm / d MMM yyyy / E"     /*    "HH:mm MMM d, yyyy"      */
        let currentFormattedDate = format.string(from: currentDate)
        return currentFormattedDate
    }
    
    func saveGameResult () {
        let date = getCurrentDate()
        let currentResult = Results(name: userName, score: score, gameDate: date)
        if var resultsList = UserDefaults.standard.value([Results].self, forKey: "results") {
            resultsList.append(currentResult)
            UserDefaults.standard.set(encodable: resultsList, forKey: "results")
        } else {
            var resultsList: [Results] = []
            resultsList.append(currentResult)
            UserDefaults.standard.set(encodable: resultsList, forKey: "results")
        }
 
        }
    
    func getSettings() {
        if UserDefaults.standard.value(forKey: "settings") == nil {
            debugPrint("I haven't got settings - load default settngs")
            self.loadDefaultSettings()
        } else {
            self.loadSettings()
        }
    }
    
    func loadDefaultSettings() {
        let settings = Settings(submarine: 1, speed: 1, name: "User", fish: true, torpeda: true, ship: true)
        UserDefaults.standard.set(encodable: settings, forKey: "settings")
    }
    
    func loadSettings() {
        guard let settings = UserDefaults.standard.value(Settings.self, forKey: "settings") else { return }
        self.userNameLabel.text = settings.name
        self.speedGame = settings.speed
        self.userName = settings.name
        switch settings.submarine {
        case 1:
            let image = UIImage(named: "mySubmarin")
            self.mySubmarineView.image = image
        case 2:
            let image = UIImage(named: "mySubmarinBlue")
            self.mySubmarineView.image = image
        case 3:
            let image = UIImage(named: "mySubmarinRed")
            self.mySubmarineView.image = image
        case 4:
            let image = UIImage(named: "mySubmarinGreen")
            self.mySubmarineView.image = image
        default:
            let image = UIImage(named: "mySubmarin")
            self.mySubmarineView.image = image
        }
    }
    
    func showGameOverController () {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "GameOverViewController") as? GameOverViewController else {return}
             self.navigationController?.pushViewController(controller, animated: true)
        controller.score = self.score
    }
    
    func gameEnd() {
        self.stopAllTimers()
        self.saveGameResult()
        self.showGameOverController()
    }
    
    func setupGameDifficulty() {
        guard let settings = UserDefaults.standard.value(Settings.self, forKey: "settings") else { return }
        switch self.speedGame {
        case 1:
            self.timeForAnimationObstacles = 4.5
            self.timeForAnimationCoinAndHealth = 5
        case 2:
            self.timeForAnimationObstacles = 3
            self.timeForAnimationCoinAndHealth = 4
        case 3:
            self.timeForAnimationObstacles = 2
            self.timeForAnimationCoinAndHealth = 3.5
        default:
            self.timeForAnimationObstacles = 4.5
            self.timeForAnimationCoinAndHealth = 5
        }
        if settings.fish == true {
            debugPrint("Fish is: \(settings.fish)")
            self.fishTimer()
        }
        if settings.torpeda == true {
            debugPrint("Torpeda is: \(settings.torpeda)")
            self.torpedaTimer()
        }
        if settings.ship == true {
            debugPrint("Ship is: \(settings.ship)")
            self.shipTimer()
        }
    }
    
    func localize() {
        let scoreTitle = "GameScore".localized
        self.scoreLabel.text = scoreTitle
        
        let backButton = "Back".localized
        self.backButton.setTitle(backButton,
                                 for: .normal)
        
        let userNameLabel = "UserNameLabel".localized
        self.playerName.text = userNameLabel
    }

        
}
