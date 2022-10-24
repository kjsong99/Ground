import UIKit

class MyViewController: UIViewController {
    
    // MARK - PROPERTY
    
    var postsData : PostsResponse?

    // MARK - OUTLET
    
    @IBOutlet var myTableView: UITableView!
    
    // MARK - OVERRIDE
    override func viewWillAppear(_ animated: Bool) {
        viewInit()
    }
    
    override func viewDidLoad() {
        myTableView.delegate = self
        myTableView.dataSource = self
        viewInit()
    }
    
    // MARK - METHOD
    
    func viewInit(){
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

// MARK - EXTENSION

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
            cell.nameLabel.text = data[indexPath.row].user.username
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
        if let data = postsData{
            
            postVC.id = data[indexPath.row].id
            
            self.navigationController?.pushViewController(postVC, animated: true)
        }
    }
    
    
}
