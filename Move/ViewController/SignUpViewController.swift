
import UIKit
import SwiftKeychainWrapper

class SignUpViewController: UIViewController{
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var userNameText: UITextField!
    @IBOutlet var passwordConfirmText: UITextField!

    
    
    @IBOutlet var emailErrorText: UILabel!
    @IBOutlet var passwordErrorText: UILabel!
    @IBOutlet var passwordConfirmErrorText: UILabel!
    @IBOutlet var usernameErrorText: UILabel!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
 
    
    override func viewDidLoad() {
        
       
        
        emailText.delegate = self
        passwordText.delegate = self
        userNameText.delegate = self
        passwordConfirmText.delegate = self
        
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
                    try await API.signUp(email: email,
                                       password: password,
                                       username: username)

                    let main = UIStoryboard.init(name: "Main", bundle: nil)
                    guard let vc = main.instantiateInitialViewController() else{

                        return
                    }
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)

                }catch{
                    throw error
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
    

    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailText {
            passwordText.becomeFirstResponder()
        }else if textField == passwordText{
            passwordConfirmText.becomeFirstResponder()
            
        }else if textField == passwordConfirmText{
            userNameText.becomeFirstResponder()
        }else{
            userNameText.resignFirstResponder()
        }
        
        return true
    }
}
