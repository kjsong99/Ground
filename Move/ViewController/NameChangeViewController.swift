//
//  NameChangeViewController.swift
//  Move
//
//  Created by 송경진 on 2022/10/10.
//

import UIKit

protocol SettingDelegate : AnyObject{
    func refresh()
}

class NameChangeViewController: UIViewController {
    
    @IBOutlet var nameText: UITextField!
    @IBOutlet var existBtn: UIButton!
    @IBOutlet var nameSetBtn: UIButton!
    var delegate : SettingDelegate?
    
    //let id = UserDefaults.standard.string(forKey: "id")!
    
    override func viewDidLoad() {
        //delegate 설정
        Task{
            do{
                nameText.text = try await API.getUser().username
                nameText.addTarget(self, action: #selector(self.usernameDidChange(_:)), for: .editingChanged)
            }catch{
                print(error)
                throw error
            }
        }
       
    }
    
    @objc func usernameDidChange(_ sender: Any){
        guard let username = nameText.text else {
            return
        }
        if username == "" {
            existBtn.configuration!.background.strokeColor = UIColor.darkGray
            existBtn.isEnabled = false
            nameSetBtn.isEnabled = false
        }else{
            existBtn.configuration!.background.strokeColor = UIColor.red
            existBtn.isEnabled = true
        }
    }
    
    @IBAction func existBtnTapped(_ sender: Any) {
        Task{
            do{
                if try await API.isNameExist(name: nameText.text ?? ""){
                    nameSetBtn.isEnabled = false
                }else{
                    nameSetBtn.isEnabled = true
                }
            }catch{
                print(error)
                throw error
            }
        }
        
    }
    
    @IBAction func setNameBtnTapped(_ sender: Any) {
        Task{
            do{
                try await API.changeName(username: nameText.text ?? "")
                delegate?.refresh()
                navigationController?.popViewController(animated: true)
            }catch{
                print(error)
                throw error
            }
        }
    }
    
    
}

