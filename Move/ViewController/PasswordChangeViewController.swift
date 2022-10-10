//
//  PasswordChangeViewController.swift
//  Move
//
//  Created by 송경진 on 2022/10/10.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    var currentPwdVisible : Bool = false
    var newPwdVisible : Bool = false
    var newPwdConfirmVisible : Bool = false
    @IBOutlet var newPwd: UITextField!
    @IBOutlet var newPwdConfirm: UITextField!
    @IBOutlet var currentPwd: UITextField!
    
    @IBAction func currentVisibleTapped(_ sender: Any) {
        if currentPwdVisible{
            currentPwdVisible = false
            currentPwd.isSecureTextEntry = true
        }else{
            currentPwdVisible = true
            currentPwd.isSecureTextEntry = false

        }
    }
    
    @IBAction func newVisibleTapped(_ sender: Any) {
        if newPwdVisible{
            newPwdVisible = false
            newPwd.isSecureTextEntry = true
        }else{
            newPwdVisible = true
            newPwd.isSecureTextEntry = false

        }
    }
    
    @IBAction func newConfirmVisibleTapped(_ sender: Any) {
        if newPwdConfirmVisible{
            newPwdConfirmVisible = false
            newPwdConfirm.isSecureTextEntry = true
        }else{
            newPwdConfirmVisible = true
            newPwdConfirm.isSecureTextEntry = false

        }
    }
    
    @IBAction func pwdChangeBtnTapped(_ sender: Any) {
        if newPwd.text != newPwdConfirm.text {
            let alert = UIAlertController(title: nil, message: "새 비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            Task{
                do{
                    if try await API.currentPassword(id: UserDefaults.standard.string(forKey: "id")!, password: currentPwd.text!){
                        
                        try await API.changePassword(id: UserDefaults.standard.string(forKey: "id")!, password: newPwd.text!)
                        
                        let alert = UIAlertController(title: nil, message: "비밀번호가 변경되었습니다..", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        self.present(alert, animated: true)
                       
                        
                        
                    }
                }catch{
                    let alert = UIAlertController(title: nil, message: "현재 비밀번호가 틀렸습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
}
