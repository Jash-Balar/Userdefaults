import UIKit

class ViewController: UIViewController {
  
    private var isOnboarded: Bool = UserDefaults.isOnboarded
    private var isDay: Bool = UserDefaults.isDay
    private var userModel: UserModel = UserDefaults.userModel
    private var netflixModel: NetflixModel = UserDefaults.netflixModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isOnboarded {
            // some code
            UserDefaults.isDay = true
        }
        
        if isDay {
            // some code
            UserDefaults.isOnboarded.toggle()
        }
        
        let userName = userModel.name
        print(userName)
        // prints ===>>> Jash
        
        if userName == "Jash" {
            // assigning the value to the Userdefault variable directly
            UserDefaults.userModel.age = 10
        }
    }
}
