import UIKit

class NameChangeViewController: UIViewController {
    
    // MARK - OUTLET
    
    @IBOutlet var nameText: UITextField!
    @IBOutlet var existBtn: UIButton!
    @IBOutlet var nameSetBtn: UIButton!
    
    // MARK - OVERRIDE
    
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
                navigationController?.popViewController(animated: true)
            }catch{
                print(error)
                throw error
            }
        }
    }
    
    override func viewDidLoad() {
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
    
    // MARK - METHOD
    
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
}

