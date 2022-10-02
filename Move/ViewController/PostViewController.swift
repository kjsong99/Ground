//
//  PostViewController.swift
//  Move
//
//  Created by 송경진 on 2022/09/29.
//

import UIKit
import Alamofire

// MARK - protocol
protocol SearchDelegate : AnyObject{
    func refreshSearch()
}

class PostViewController: UIViewController{
    
    
    // MARK - variable
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var userLabel: UILabel!
    var id : Int = 0
    var postData : PostsResponseElement?
    weak var delegate : BoardDelegate?
    weak var searchDelegate : SearchDelegate?
    
    
    // MARK - override
    override func viewDidLoad() {
        super.viewDidLoad()
        Task{
            do{
                postData = try await API.getPost(id: id)
                setData()
                contentLabel.sizeToFit()
                
            }catch{
               throw error
            }
        }
    }
    
    // MARK - method
    func setData(){
        if let post = postData {
            
            titleLabel.text = post.title
            contentLabel.text = post.content
            userLabel.text = post.user?.username
            
            
            if let date = post.created_at.dateUTC(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"){
                let str = date.string(format: "MM/dd HH:mm")
                dateLabel.text = str
            }
        }
    }
    
    
    @IBAction func showMoreButton(_ sender: Any){
   
        guard let user = UserDefaults.standard.string(forKey: "id") else{
            return
        }
        
        let actionSheet = UIAlertController(title: "글메뉴", message: nil, preferredStyle: .actionSheet)
        //취소 버튼 - 스타일(cancel)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        //여기서 글쓴이인지 확인
       
        if user == postData!.user?.id.description{
            actionSheet.addAction(UIAlertAction(title: "수정", style: .default, handler: {(ACTION:UIAlertAction) in
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "WriteVC") as? WriteViewController{
                    vc.postDelegate = self
                    vc.delegate = self.delegate
                    vc.modifyPost = self.postData!
                    vc.searchDelegate = self.searchDelegate
                    self.show(vc, sender: self)
                }
            }))
       
          
           
            actionSheet.addAction(UIAlertAction(title: "삭제", style: .default, handler: {(ACTION:UIAlertAction) in
                let sheet = UIAlertController(title: nil, message: "정말 삭제하겠습니까?", preferredStyle: .alert)
                sheet.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
                    Task{
                        do{
                            try await API.deletePost(id: self.id.description)
                            self.delegate?.refreshBoard()
                            self.searchDelegate?.refreshSearch()
                            self.navigationController?.popViewController(animated: true)
                        }catch{
                            throw error
                        }
                        
                    }
                    
                }))
                sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {_ in
                }))
                self.present(sheet,animated: true)
                
                
            }))
            
         
            
        }else{
            //글쓴이가 아닐때
            //쪽지, 신고 등등?

            
        }
        
        
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
  
    
}



extension PostViewController : PostDelegate{
    func refreshPost() async throws{
        Task{
            do{
                print("refreshPost")
                postData = try await API.getPost(id: self.id)
                titleLabel.text = self.postData!.title
                contentLabel.text = self.postData!.content
                
            }catch{
                throw error
            }
            
        }
       
    }
    
    
}
