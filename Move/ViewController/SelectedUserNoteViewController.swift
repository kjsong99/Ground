import UIKit

class SelectedUserNoteViewController: UIViewController {
    
    // MARK - PROPERTY
    
    var data: NotesResponse?
    var id : Int?
    
    // MARK - OUTLET
    
    @IBOutlet var selectedNoteTableVIew: UITableView!
    
    // MARK - OVERRIDE
    
    override func viewWillAppear(_ animated: Bool) {
        Task{
            do{
                data = try await API.getNotesbyCertainUser(user: id!)
                selectedNoteTableVIew.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        selectedNoteTableVIew.delegate = self
        selectedNoteTableVIew.dataSource = self
        
    }
    
}

// MARK - EXTENSION

extension SelectedUserNoteViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectedUserNoteTableViewCell
        if let data = data{
            cell.content.text = data[indexPath.row].content
            cell.date.text = data[indexPath.row].created_at.dateUTC(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")?.string(format: "yy/MM/dd HH:mm")
            API.getId()
            if data[indexPath.row].send_user.id.description == API.id {
                cell.statusLabel.sendLabel()
            }else{
                cell.statusLabel.receiveLabel()
            }
        }
        return cell
    }
}

extension UILabel{
    func sendLabel(){
        self.text = "보낸 쪽지"
        self.textColor = UIColor.systemYellow
    }
    
    func receiveLabel(){
        self.text = "받은 쪽지"
        self.textColor = UIColor.systemGreen
    }
}
