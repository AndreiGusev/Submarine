import UIKit

//MARK: - class
class ViewController: UIViewController {
    
    // MARK: - IBoutlets
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    // MARK: - lifecycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage.addParalax()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.gameButton.dropShadow()
        self.scoreButton.dropShadow()
        self.settingsButton.dropShadow()
        self.localize()
    }

    // MARK: - IBAction
    @IBAction func gameButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {return}
        self.navigationController?.pushViewController(controller, animated: true)
           }

    @IBAction func scoreButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "RxScoreViewController") as? RxScoreViewController else {return}
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {return}
             self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func localize() {
        let scoreButtonTitle = "Score".localized
        self.scoreButton.setTitle(scoreButtonTitle,
                                    for: .normal)

        let settingsButtonTitle = "Settings".localized
        self.settingsButton.setTitle(settingsButtonTitle,
                                    for: .normal)

        let gameButtonTitle = "Game".localized
        self.gameButton.setTitle(gameButtonTitle,
                                    for: .normal)
    }
    
}




