import UIKit

class NoteViewController: UIViewController {
    
    // MARK - PROPERTY
    
    var data : NotesResponse?
    
    // MARK - OUTLET
    
    @IBOutlet var noteTableView: UITableView!
    
    // MARK - OVERRIDE
    
    override func viewDidLoad() {
        noteTableView.delegate = self
        noteTableView.dataSource = self
        Task{
            do{
                data = try await API.getNotes()
                noteTableView.reloadData()
            }
        }
    }
    
}

// MARK - EXTENSION

extension NoteViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NoteTableViewCell

        if let data = data{
            API.getId()
            cell?.username.text = data[indexPath.row].send_user.id.description == API.id ? data[indexPath.row].receive_user.username : data[indexPath.row].send_user.username
            cell?.content.text = data[indexPath.row].content
            cell?.date.text = data[indexPath.row].created_at.dateUTC(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")?.string(format: "yy/MM/dd HH:mm")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedNoteVC") as? SelectedUserNoteViewController
        API.getId()
        if data![indexPath.row].send_user.id.description == API.id {
            vc!.id = data![indexPath.row].receive_user.id
            vc!.title = data![indexPath.row].receive_user.username
        }else{
            vc!.id = data![indexPath.row].send_user.id
            vc!.title = data![indexPath.row].send_user.username
        }
        self.show(vc!, sender: self)
        
    }
    
    
}
