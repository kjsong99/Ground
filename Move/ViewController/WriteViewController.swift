//
//  WriteViewController.swift
//  Move
//
//  Created by 송경진 on 2022/08/31.
//
import Alamofire
import UIKit

protocol BoardDelegate : AnyObject{
    func refreshBoard()
}

protocol PostDelegate : AnyObject{
    func refreshPost() async
}

class WriteViewController: UIViewController{
    
    // MARK - Variable
    
    @IBOutlet var titleText: UITextField!
    @IBOutlet var contentText: UITextView!
    var modifyPost : PostsResponseElement?
    weak var delegate: BoardDelegate?
    weak var postDelegate: PostDelegate?
    weak var searchDelegate: SearchDelegate?
    
    
    
    
    
    // MARK - Method
    
    override func viewDidLoad() {
        contentText.delegate = self
        contentText.layer.borderWidth = 0.2
        contentText.layer.cornerRadius = 5.0
        contentText.layer.borderColor = UIColor.systemGray.cgColor
    
      
        
        if modifyPost != nil {
            titleText.text = modifyPost?.title
            contentText.text = modifyPost?.content
        }else{
           
            contentText.text = "내용을 입력하세요."
            contentText.textColor = UIColor.systemGray3
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func submitTouched(_ sender: Any) {
        
        guard let title = titleText.text else {
            return
        }
        guard let content = contentText.text else{
            return
        }
            
        print(modifyPost)
        Task{
            if modifyPost == nil{
                try? await postData(title: title, content: content)
            }else{
                try? await modify(title: title, content: content)
                //board가 아니라 post delegate 위임해서 데이터 업데이트 해야함.
                 await postDelegate?.refreshPost()
            }
            
            delegate?.refreshBoard()
            searchDelegate?.refreshSearch()
            navigationController?.popViewController(animated: true)
        }
//        if modifyPost == nil {
//            //글쓰기
//            Task{
//               
////                delegate?.refreshBoard()
////                navigationController?.popViewController(animated: true)
//            }
//        }else{
//            //수정
//            Task{
//              
//            }
//        }
    
      
       
    }
    
    private func postData(title: String, content: String) async throws{
        let url =  "\(Bundle.main.url)posts"
        guard let id = UserDefaults.standard.string(forKey: "id") else {
            return
        }
        let param : Parameters = [
            "title" : title,
            "content" : content,
            "user": id
        ]
        
        do{
            _ = try await
            AppNetworking.shared.requestJSON(url, type: WriteResponse.self, method: .post, parameters: param)
        }catch{
            return
        }
    }
    
    private func modify(title: String, content: String) async throws{
        let url =  "\(Bundle.main.url)posts/" + (modifyPost?.id.description)!
        guard let id = UserDefaults.standard.string(forKey: "id") else {
            return
        }
        let param : Parameters = [
            "title" : title,
            "content" : content
        ]
        
        do{
            _ = try await
            AppNetworking.shared.requestJSON(url, type: WriteResponse.self, method: .put, parameters: param)
        }catch{
            return
        }
    }
}

extension WriteViewController : UITextViewDelegate{
    //MARK: - TextView Delegate
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

