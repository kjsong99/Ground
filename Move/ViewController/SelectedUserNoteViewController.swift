//
//  SelectedUserNoteViewController.swift
//  Move
//
//  Created by 송경진 on 2022/10/22.
//

import UIKit

class SelectedUserNoteViewController: UIViewController {
    var id : String?
    @IBOutlet var selectedNoteTableVIew: UITableView!
    
    override func viewDidLoad() {
        print(id!)
        selectedNoteTableVIew.delegate = self
        selectedNoteTableVIew.dataSource = self
    }
    
}
extension SelectedUserNoteViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}
