//
//  WriteViewController.swift
//  Move
//
//  Created by 송경진 on 2022/08/31.
//
import Alamofire
import UIKit

protocol NotificationDelegate : AnyObject{
    func refresh()
}

class WriteViewController: UIViewController {
    
    // MARK - Variable
    
    @IBOutlet var titleText: UITextField!
    @IBOutlet var contentText: UITextField!
    weak var delegate: NotificationDelegate?
    
    
    
    // MARK - Method
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func submitTouched(_ sender: Any) {
        print("touched")
        guard let title = titleText.text else {
            return
        }
        guard let content = contentText.text else{
            return
        }
        Task{
            try? await postData(title: title, content: content)
            delegate?.refresh()
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func postData(title: String, content: String) async throws{
        let url =  "\(Bundle.main.url)posts"
        guard let id = UserDefaults.standard.string(forKey: "id") else {
            return
        }
        
        print(id)
        
        
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
}

