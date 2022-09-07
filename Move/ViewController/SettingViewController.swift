
import UIKit
import SwiftKeychainWrapper

class SettingViewController: UIViewController {
    
    
    
    @IBAction func SignOutBtnTapped(_ sender: Any) {
        print("sign out")
        KeychainWrapper.standard.removeObject(forKey: "auth")
        UserDefaults.standard.removeObject(forKey: "id")
        
        let sb = UIStoryboard(name: "Login", bundle: nil)
        guard let vc = sb.instantiateInitialViewController() else { return }
        
        
        
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true)
    }
    
    

}
