//
//  NoteViewController.swift
//  Move
//
//  Created by 송경진 on 2022/10/20.
//

import UIKit

class NoteViewController: UIViewController {
    var data : NotesResponse?
    @IBOutlet var noteTableView: UITableView!
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

extension NoteViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NoteTableViewCell
        let id = UserDefaults.standard.string(forKey: "id")!
        if let data = data{
            
            cell?.username.text = data[indexPath.row].send_user!.id.description == id ? data[indexPath.row].receive_user!.username : data[indexPath.row].send_user?.username
            cell?.content.text = data[indexPath.row].content
            cell?.date.text = data[indexPath.row].created_at.date(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")?.string(format: "yy/MM/dd HH:mm")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedNoteVC") as? SelectedUserNoteViewController
        vc!.id = "test"
        
        self.show(vc!, sender: self)
        
    }
    
    
}
