//
//  PostViewController.swift
//  Move
//
//  Created by 송경진 on 2022/09/29.
//

import UIKit
import Alamofire

class PostViewController: UIViewController{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var userLabel: UILabel!

    var id : Int = 0
    var temp = [PostsResponseElement]()
    weak var delegate : BoardDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task{
            do{
               try await getPost(id: id)
                setData()
                
            }catch{
                print(error)
            }
            contentLabel.sizeToFit()
        }
    }
    
    func setData(){
        
            titleLabel.text = temp[0].title
            contentLabel.text = temp[0].content
            userLabel.text = temp[0].user?.username


            guard let date = temp[0].created_at.dateUTC(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") else{
                return
            }
            let str = date.string(format: "MM/dd HH:mm")
            dateLabel.text = str
    }
    
    
    @IBAction func showMoreButton(_ sender: Any){
   
        let actionSheet = UIAlertController(title: "글메뉴", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "수정", style: .default, handler: {(ACTION:UIAlertAction) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WriteVC") as? WriteViewController
            vc?.postDelegate = self
            vc?.delegate = self.delegate
            vc?.modifyPost = self.temp[0]
            self.show(vc!, sender: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "삭제", style: .default, handler: {(ACTION:UIAlertAction) in
            Task{
                try? await deletePost(id: String(self.id))
                    //refresh
                self.delegate?.refreshBoard()
                self.navigationController?.popViewController(animated: true)
            }
            
        }))
        
        //취소 버튼 - 스타일(cancel)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        
        
    }
    
    func getPost(id: Int) async throws {
        let url =  "\(Bundle.main.url)posts/"+String(id)
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: PostsResponseElement.self, method: .get)
            
//            titleLabel.text = data.title
//            contentLabel.text = data.content
//            userLabel.text = data.user?.username
//
//
//            guard let date = data.created_at.dateUTC(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") else{
//                return
//            }
//            let str = date.string(format: "MM/dd HH:mm")
//            dateLabel.text = str
            if !temp.isEmpty{
                temp.removeAll()
            }
            temp.append(data)
            
           
            
        }
    }
    
}

func modifyPost(){
    
}

func deletePost(id: String) async throws{
    let url =  "\(Bundle.main.url)posts/\(id)"
    
    do{
        _ = try await AppNetworking.shared.requestJSON(url, type: WriteResponse.self, method: .delete)
    }catch{
        return
    }
    
    
}

extension PostViewController : PostDelegate{
    func refreshPost() async{
        try? await getPost(id: self.id)
        titleLabel.text = self.temp[0].title
        contentLabel.text = self.temp[0].content
    }
    
    
}
