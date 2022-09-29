//
//  PostViewController.swift
//  Move
//
//  Created by 송경진 on 2022/09/29.
//

import UIKit
import Alamofire

class PostViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var userLabel: UILabel!
    var id : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task{
            try? await getPost(id: id)
            contentLabel.sizeToFit()
        }
        
//        contentLabel.text = String(id)
    }
    
    func getPost(id: Int) async throws{
        let url =  "\(Bundle.main.url)posts/"+String(id)
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: PostsResponseElement.self, method: .get)
                    
            titleLabel.text = data.title
            contentLabel.text = data.content
            userLabel.text = data.user?.username
           
            
        }
        
        
        
        
        
    }
}
