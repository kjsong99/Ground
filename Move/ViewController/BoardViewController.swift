import UIKit
import Foundation

class BoardViewController: UIViewController{
    
    // MARK - PROPERTY
    
    var postsData : PostsResponse?
    
    // MARK - OUTLET
    
    @IBOutlet lazy var postsTableView: UITableView! = UITableView()
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as? SearchViewController {
            self.navigationController?.show(vc, sender: self)
        }
    }
    
    // MARK - OVERRIDE
    override func viewDidLoad() {
        postsTableView.dataSource = self
        postsTableView.delegate = self
        viewInit()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewInit()
    }
    
    
    // MARK - METHOD
    
    func viewInit(){
        Task{
            do{
                postsData = try await API.getPosts()
                self.postsTableView.reloadData()
                
            }catch{
                print(error)
                throw error
            }
        }
        
    }
}

// MARK - EXTENSION

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
            cell.nameLabel.text = data[indexPath.row].user.username
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
        if let data = postsData{
            postVC.id = data[indexPath.row].id
            //            postVC.delegate = self
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

