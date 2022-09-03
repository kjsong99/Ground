
import UIKit
import SwiftKeychainWrapper

class SignUpViewController: UIViewController {
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var userNameText: UITextField!
    @IBOutlet var passwordConfirmText: UITextField!
    
    
    @IBOutlet var emailErrorText: UILabel!
    @IBOutlet var passwordErrorText: UILabel!
    @IBOutlet var passwordConfirmErrorText: UILabel!
    @IBOutlet var usernameErrorText: UILabel!
    
    override func viewDidLoad() {
        
        emailText.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
        passwordConfirmText.addTarget(self, action: #selector(passwordConfirmDidChange(_:)), for: .editingChanged)
        passwordText.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        userNameText.addTarget(self, action: #selector(usernameDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func emailDidChange(_ sender: Any){
        guard let email = emailText.text else {
            return
        }
        
        if email == "" {
            emailErrorText.isHidden = false
        }else{
            emailErrorText.isHidden = true
        }
    }
    
    @objc func passwordDidChange(_ sender: Any){
        guard let password = passwordText.text else {
            return
        }
        if password == "" {
            passwordErrorText.isHidden = false
        }else{
           passwordErrorText.isHidden = true
        }
    }
    
    @objc func usernameDidChange(_ sender: Any){
        guard let username = userNameText.text else {
            return
        }
        if username == "" {
            usernameErrorText.isHidden = false
        }else{
            usernameErrorText.isHidden = true
        }
    }
    
    @objc func passwordConfirmDidChange(_ sender: Any){
        guard let password = passwordText.text else{
            return
        }
        if password != ""{
            if password != passwordConfirmText.text{
                passwordConfirmErrorText.isHidden = false
            }else{
                passwordConfirmErrorText.isHidden = true
            }
        }else{
            passwordConfirmErrorText.isHidden = true
        }
    }
    
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        
        guard let email = emailText.text else{
            return
        }
        guard let password = passwordText.text else{
            return
        }
        
        guard let passwordConfirm = passwordConfirmText.text else{
            return
        }
        guard let username = userNameText.text else{
            return
        }
        
        if email != "" && password != "" && passwordConfirm != "" && username != "" && password == passwordConfirm {
            Task{
                do{
                    try await signUp(email: email,
                                       password: password,
                                       username: username)
                }catch{
                    return
                }
               
            }
            
        }else{
            if email == "" {
                emailErrorText.isHidden = false
            }
            if password == "" {
                passwordErrorText.isHidden = false
            }
            if passwordConfirm == ""{
                passwordConfirmErrorText.isHidden = false
            }
            if username == "" {
                usernameErrorText.isHidden = false
            }
            
            if password != passwordConfirm {
                passwordConfirmErrorText.isHidden = false
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
