import UIKit

//MARK: - class
class GameOverViewController: UIViewController {

    var score = 0
    
    // MARK: - IBoutlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var yourScoreLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - lifecycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scoreLabel.text = String(score)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.localize()
    }
   
    // MARK: - IBAction
    @IBAction func retryButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {return}
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - flow funcs
    func localize() {
        let retry = "Retry".localized
        self.retryButton.setTitle(retry,
                                 for: .normal)
        let cancel = "Cancel".localized
        self.cancelButton.setTitle(cancel,
                                 for: .normal)
        
        let gameOver = "Game over".localized
        self.gameOverLabel.text = gameOver
        
        let yourScore = "Your score".localized
        self.yourScoreLabel.text = yourScore
    }
}
