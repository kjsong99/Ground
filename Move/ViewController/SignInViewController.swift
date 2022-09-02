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
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        guard let email = emailText.text as? String else {
            return
        }
        guard let password = passwordText.text as? String else {
            return
        }
        
        Task{
            try? await signIn(email: email, password: password)
        }
        
    }
    
    func signIn(email: String, password: String) async throws{
        
        let url = "\(Bundle.main.url)api/auth/local"
        let param = [
            "identifier" : email,
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
