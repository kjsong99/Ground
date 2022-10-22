//
//  ViewController.swift
//  Move
//
//  Created by 송경진 on 2022/08/09.
//

import UIKit
import Alamofire
import Foundation

class BoardViewController: UIViewController{
    
    // MARK - Variable
    
    var postsData : PostsResponse?
    @IBOutlet lazy var postsTableView: UITableView! = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        Task{
            do{
                postsData = try await API.getPosts()
                self.postsTableView.reloadData()
                
            }catch{
                throw error
            }
        }
    }
    // MARK - Override
    override func viewDidLoad() {
        
        Task{
            postsTableView.dataSource = self
            postsTableView.delegate = self
            do{
                postsData = try await API.getPosts()
                self.postsTableView.reloadData()
                
            }catch{
                throw error
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show"{
            let vc : WriteViewController = segue.destination as! WriteViewController
            vc.delegate = self
        }
        
    }
    
    
    // MARK - Method
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as? SearchViewController {
            vc.delegate = self
            self.navigationController?.show(vc, sender: self)
        }
    }

}

// MARK - EXTENSION

extension BoardViewController : BoardDelegate{
    func refreshBoard() {
        Task{
            do{
                self.postsData =  try await API.getPosts()
                self.postsTableView.reloadData()
                
            }catch{
                throw error
            }
        }
        
    }
}


extension BoardViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData?.count ?? 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "posts", for: indexPath) as! PostsTableViewCell
        if let data = postsData{
            cell.titleLabel.text = data[indexPath.row].title
            cell.dateLabel.text = Util.setDate(row: indexPath.row, inputDate: data[indexPath.row].createdAt)
            cell.contentLabel.text = data[indexPath.row].content
            cell.nameLabel.text = data[indexPath.row].user?.username
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
        if let data = postsData{
            postVC.id = data[indexPath.row].id
            postVC.delegate = self
            self.navigationController?.pushViewController(postVC, animated: true)
        }
        
    }
    
    //삭제는 들어가서 하기!
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //        return .delete
    //    }
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete{
    //            Task{
    //                let id = postsData[0][indexPath.row].id.description
    //                try? await deletePost(id: id)
    //                try? await getData()
    //            }
    //
    //        }
    
    //    }
    
}

