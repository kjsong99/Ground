//
//  MyViewController.swift
//  Move
//
//  Created by 송경진 on 2022/10/15.
//

import UIKit

class MyViewController: UIViewController {
    @IBOutlet var myTableView: UITableView!
    var postsData : PostsResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        Task{
            do{
                postsData = try await API.getMyPosts()
                myTableView.reloadData()
                
            }catch{
                print(error)
                throw error
            }
        }
    }

}
extension MyViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "MyPosts", for: indexPath) as! PostsTableViewCell
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
        postVC.myDelegate = self
        if let data = postsData{
            
            postVC.id = data[indexPath.row].id
//            postVC.delegate = self.delegate
            
            self.navigationController?.pushViewController(postVC, animated: true)
        }
    }
    
    
}

extension MyViewController : MyDelegate{
    func refreshMyView(){
        Task{
            do{
                postsData = try await API.getMyPosts()
                myTableView.reloadData()
            }catch{
                print(error)
                throw error
            }
        }
    }
    
}
