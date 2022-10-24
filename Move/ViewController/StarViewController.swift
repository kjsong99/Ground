import UIKit

class StarViewController: UIViewController {
    
    // MARK - PROPERTY
    
    var postsData : StarResponse?
    
    // MARK - OUTLET
    
    @IBOutlet var starTableView: UITableView!
    
    // MARK - OVERRIDE
    
    override func viewWillAppear(_ animated: Bool) {
        viewInit()
    }
    
    override func viewDidLoad() {
        starTableView.delegate = self
        starTableView.dataSource = self
        viewInit()
    }
    
    // MARK - METHOD
    
    func viewInit(){
        Task{
            do{
                postsData = try await API.getStarPosts()
                starTableView.reloadData()
                
            }catch{
                print(error)
                throw error
            }
        }
    }
}

// MARK - EXTENSION

extension StarViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = starTableView.dequeueReusableCell(withIdentifier: "StarPosts", for: indexPath) as! PostsTableViewCell
        
        if let data = postsData{
            Task{
                cell.titleLabel.text = data[indexPath.row].post.title
                cell.dateLabel.text = Util.setDate(row: indexPath.row, inputDate: (data[indexPath.row].post.createdAt ?? ""))
                cell.contentLabel.text = data[indexPath.row].post.content
                cell.nameLabel.text = try await API.getUser(id: data[indexPath.row].post.user.id.description ?? "").username
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
        
        
        if let data = postsData{
            
            postVC.id = data[indexPath.row].post.id ?? 0
            
            self.navigationController?.pushViewController(postVC, animated: true)
        }
    }
    
    
}
