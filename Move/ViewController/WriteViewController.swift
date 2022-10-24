import UIKit

class WriteViewController: UIViewController{
    
    // MARK - PROPERTY
    
    var modifyPost : PostClass?
    
    // MARK - OUTLET
    
    @IBOutlet var titleText: UITextField!
    @IBOutlet var contentText: UITextView!
    
    @IBAction func submitTouched(_ sender: Any) {
        
        
        guard let title = titleText.text else {
            return
        }
        guard let content = contentText.text else{
            return
        }
        
        Task{
            do{
                
                if modifyPost == nil{
                    try await API.createPost(title: title, content: content)
                }else{
                    try await API.modify(title: title, content: content, id: self.modifyPost!.id)
                    
                }
                navigationController?.popViewController(animated: true)
                
            }catch{
                throw error
            }
        }
    }
    
    // MARK - OERRIDE
    
    override func viewDidLoad() {
        contentText.delegate = self
        if modifyPost != nil {
            titleText.text = modifyPost?.title
            contentText.text = modifyPost?.content
        }else{
            contentText.text = "내용을 입력하세요."
            contentText.textColor = UIColor.systemGray2
            contentText.layer.borderWidth = 1.0
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK - EXTENSION
extension WriteViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력하세요." {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요."
            textView.textColor = UIColor.systemGray3
        }
    }
}

