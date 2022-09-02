
import UIKit
import SwiftKeychainWrapper

class SignUpViewController: UIViewController {
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var userNameText: UITextField!
    
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        
        guard let email = emailText.text else{
            return
        }
        guard let password = passwordText.text else{
            return
        }
        guard let username = userNameText.text else{
            return
        }
        
        print(username)
        
        Task{
            do{
                try await signUp(email: email,
                                   password: password,
                                   username: username)
            }catch{
                return
            }
           
        }
       
    }
    
    func signUp(email: String, password: String, username: String) async throws{
        let url = "\(Bundle.main.url)api/auth/local/register"
        let param = [
            "username" : username,
            "email" : email,
            "password" : password
            
        ]
        
        do{
            let data = try await
            AppNetworking.shared.requestJSON(url, type: RegisterResponse.self, method: .post, parameters: param)
            
            if (KeychainWrapper.standard.string(forKey: "auth") != nil){
                KeychainWrapper.standard.removeObject(forKey: "auth")
            }
            KeychainWrapper.standard.set(data.jwt, forKey: "auth")
            
            let main = UIStoryboard.init(name: "Main", bundle: nil)
            guard let vc = main.instantiateInitialViewController() else{
                return
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }catch{
            print(error)
        }
    }
    
}
