//
//  WriteViewController.swift
//  Move
//
//  Created by 송경진 on 2022/08/31.
//
import Alamofire
import UIKit

// MARK - protocol

protocol BoardDelegate : AnyObject{
    func refreshBoard()
}

protocol PostDelegate : AnyObject{
    func refreshPost() async throws
}

class WriteViewController: UIViewController{
    
    // MARK - Variable
    
    @IBOutlet var titleText: UITextField!
    @IBOutlet var contentText: UITextView!
    var modifyPost : PostsResponseElement?
    weak var delegate: BoardDelegate?
    weak var postDelegate: PostDelegate?
    weak var searchDelegate: SearchDelegate?
    
    
    
    
    

    // MARK - override
    
    override func viewDidLoad() {
        contentText.delegate = self
    
      
        
        if modifyPost != nil {
            titleText.text = modifyPost?.title
            contentText.text = modifyPost?.content
        }else{
           
            contentText.text = "내용을 입력하세요."
            contentText.textColor = UIColor.systemGray2
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK - Method
    
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
                    //board가 아니라 post delegate 위임해서 데이터 업데이트 해야함.
                    try await postDelegate?.refreshPost()
                }
                
                delegate?.refreshBoard()
                searchDelegate?.refreshSearch()
                navigationController?.popViewController(animated: true)
                
            }catch{
                throw error
            }
        }
    }
    
 
    

}

// MARK - extension
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

