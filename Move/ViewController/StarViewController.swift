//
//  StarViewController.swift
//  Move
//
//  Created by 송경진 on 2022/10/15.
//

import UIKit

class StarViewController: UIViewController {
    
    @IBOutlet var starTableView: UITableView!
    var postsData : StarResponse?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starTableView.delegate = self
        starTableView.dataSource = self
        Task{
            do{
                postsData = try await API.getStarPosts(id: UserDefaults.standard.string(forKey: "id")!)
                starTableView.reloadData()
                
            }catch{
                print(error)
                throw error
            }
        }
    }
    
    // Do any additional setup after loading the view.
}



extension StarViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = starTableView.dequeueReusableCell(withIdentifier: "StarPosts", for: indexPath) as! PostsTableViewCell
    
        if let data = postsData{
            Task{
                cell.titleLabel.text = data[indexPath.row].post?.title
                cell.dateLabel.text = Util.setDate(row: indexPath.row, inputDate: (data[indexPath.row].post?.createdAt ?? ""))
                cell.contentLabel.text = data[indexPath.row].post?.content
                cell.nameLabel.text = try await API.getUser(id: data[indexPath.row].post?.user?.description ?? "").username
            }
      
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
        postVC.starDelegate = self
        
        if let data = postsData{
            
            postVC.id = data[indexPath.row].post?.id ?? 0
            //            postVC.delegate = self.delegate
            
            self.navigationController?.pushViewController(postVC, animated: true)
        }
    }
    
    
}

extension StarViewController : StarDelegate{
    func refreshStar() {
        Task{
            do{
                postsData = try await API.getStarPosts(id: UserDefaults.standard.string(forKey: "id")!)
                starTableView.reloadData()
                
            }catch{
                print(error)
                throw error
            }
        }
    }
    
    
}
