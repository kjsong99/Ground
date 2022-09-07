//
//  SignInViewController.swift
//  Move
//
//  Created by 송경진 on 2022/09/02.
//

import UIKit
import SwiftKeychainWrapper


class SignInViewController: UIViewController {
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var emailErrorText: UILabel!
    @IBOutlet var passwordErrorText: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        emailText.addTarget(self, action: #selector(self.emailTextChanged(_:)), for: .editingChanged)
        
        passwordText.addTarget(self, action: #selector(self.passwordTextChanged(_:)), for: .editingChanged)
    }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        guard let  email  = emailText.text else{
            return
        }
        guard let password = passwordText.text else{
            return
        }
        
        
        if email != "" && password != "" {
            //여기서 로그인 호출
        
            
            Task{
                try? await signIn(email: email, password: password)
            }
            
        }else{
    
            //여기서 어느 필드가 공백인지 확인
            if  email == "" {
                self.emailErrorText.isHidden = false
            }
            
            if  password == ""{
                self.passwordErrorText.isHidden = false
            }
        }
        
    }
    
    @objc func emailTextChanged(_ sender: Any){
        guard let email = emailText.text else {
            return
        }
        
        if email == "" {
            emailErrorText.isHidden = false
        }else{
            emailErrorText.isHidden = true
        }
    }
    
    @objc func passwordTextChanged(_ sender: Any){
        guard let password = passwordText.text else {
            return
        }
        
        if password == "" {
            passwordErrorText.isHidden = false
        }else{
            passwordErrorText.isHidden = true
        }
    }
    
    func signIn(email: String, password: String) async throws{
        
        let url = "\(Bundle.main.url)auth/local"
        let param = [
            "identifier" : email,
            "password" : password
        ]
        
        do{
            let data = try await
            AppNetworking.shared.requestJSON(url, type: RegisterResponse.self, method: .post, parameters: param)
            
            print(data)
            
            if (KeychainWrapper.standard.string(forKey: "auth") != nil){
                KeychainWrapper.standard.removeObject(forKey: "auth")
                UserDefaults.standard.removeObject(forKey: "id")
            }
            UserDefaults.standard.set(data.user.id, forKey: "id")
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
