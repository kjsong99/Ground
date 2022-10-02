//
//  PostViewController.swift
//  Move
//
//  Created by 송경진 on 2022/09/29.
//

import UIKit
import Alamofire
protocol SearchDelegate : AnyObject{
    func refreshSearch()
}
class PostViewController: UIViewController{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var userLabel: UILabel!

    var id : Int = 0
    var temp = [PostsResponseElement]()
    weak var delegate : BoardDelegate?
    weak var searchDelegate : SearchDelegate?
    
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
            vc?.searchDelegate = self.searchDelegate
            self.show(vc!, sender: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "삭제", style: .default, handler: {(ACTION:UIAlertAction) in
            let sheet = UIAlertController(title: nil, message: "정말 삭제하겠습니까?", preferredStyle: .alert)
            sheet.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
                Task{
                    try? await deletePost(id: String(self.id))
                    self.delegate?.refreshBoard()
                    self.searchDelegate?.refreshSearch()
                    self.navigationController?.popViewController(animated: true)
                    
                }
                
            }))
            sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {_ in
                actionSheet.dismiss(animated: true)
            }))
            self.present(sheet,animated: true)
            
            //                try? await deletePost(id: String(self.id))
            //refresh
            
        }))
        
        //취소 버튼 - 스타일(cancel)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    func getPost(id: Int) async throws {
        let url =  "\(Bundle.main.url)posts/"+String(id)
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: PostsResponseElement.self, method: .get)
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
