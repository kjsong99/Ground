
import UIKit
import SwiftKeychainWrapper

class SignUpViewController: UIViewController{
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var userNameText: UITextField!
    @IBOutlet var passwordConfirmText: UITextField!
    
    @IBOutlet var signUpBtn: UIButton!
    
    var complete : [String : Bool] = [ "email" : false, "pwd" : false, "pwdConfirm" : false, "name" : false ,"check" : false , "confirm" : false]
    
    
    var isPwdVisible : Bool = false
    var isPwdConfirmVisible : Bool = false
    
    @IBOutlet var pwdErrorlabel: UILabel!
    
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
        
        if email == "" || !email.contains("@"){
            complete["email"] = false
            signUpBtn.isEnabled = false
        }else{
            complete["email"] = true
            if !complete.values.contains(false){
                signUpBtn.isEnabled = true
                
            }
            
        }
        
        
    }
    
    @objc func passwordDidChange(_ sender: Any){
        guard let password = passwordText.text else {
            return
        }
        if password == "" {
            complete["pwd"] = false
            signUpBtn.isEnabled = false
        }else{
            complete["pwd"] = true
            if !complete.values.contains(false){
                signUpBtn.isEnabled = true
            }
        }
    }
    
    @objc func passwordConfirmDidChange(_ sender: Any){
        guard let password = passwordText.text else{
            return
        }
        
        guard let passwordConfirm = passwordConfirmText.text else{
            return
        }
        
        if passwordConfirm == ""{
            complete["pwdConfirm"] = false
            signUpBtn.isEnabled = false
            
        }else{
            complete["pwdConfirm"] = true
            if !complete.values.contains(false){
                signUpBtn.isEnabled = true
            }
        }
        
        if password == passwordConfirm {
            pwdErrorlabel.isHidden = true
            complete["confirm"] = true
            if !complete.values.contains(false){
                signUpBtn.isEnabled = true
            }
        }else{
            pwdErrorlabel.isHidden = false
            complete["confirm"] = false
            signUpBtn.isEnabled = false
        }
    }
    
    @objc func usernameDidChange(_ sender: Any){
        guard let username = userNameText.text else {
            return
        }
        if username == "" {
            signUpBtn.isEnabled = false
            complete["name"] = false
        }else{
            complete["name"] = true
            if !complete.values.contains(false){
                signUpBtn.isEnabled = true
            }
        }
    }
    
    
    
    @IBAction func isNameExistBtn(_ sender: Any) {
        Task{
            guard let username = userNameText.text else {
                return
            }
            do{
                if try await API.isNameExist(name: username){
                    let alert = UIAlertController(title: nil, message: "존재하는 닉네임입니다", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }else{
                    //sign up
                    complete["check"] = true
                    if !complete.values.contains(false){
                        signUpBtn.isEnabled = true
                    }
                    let alert = UIAlertController(title: nil, message: "사용 가능한 닉네임입니다", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }catch{
                print(error)
            }
        }
    }
    
    
    @IBAction func isPasswordVisible(_ sender: Any) {
        if isPwdVisible{
            passwordText.isSecureTextEntry = true
            isPwdVisible = false
        }else{
            passwordText.isSecureTextEntry = false
            isPwdVisible = true
        }
    }
    
    
    @IBAction func isPwdConfirmVisible(_ sender: Any) {
        if isPwdConfirmVisible{
            passwordConfirmText.isSecureTextEntry = true
            isPwdConfirmVisible = false
        }else{
            passwordConfirmText.isSecureTextEntry = false
            isPwdConfirmVisible = true
        }
    }
    
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
        
        Task{
            do{
                if try await API.isEmailExist(email: email){
                    let alert = UIAlertController(title: nil, message: "이메일이 이미 존재합니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                }else{
                    try await API.signUp(email: email,
                                         password: password,
                                         username: username)
                    
                    let main = UIStoryboard.init(name: "Main", bundle: nil)
                    guard let vc = main.instantiateInitialViewController() else{
                        
                        return
                    }
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
                
                
            }catch{
                throw error
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
