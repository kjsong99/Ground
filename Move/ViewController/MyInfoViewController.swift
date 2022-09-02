//
//  MyInfoViewController.swift
//  Move
//
//  Created by 송경진 on 2022/08/30.
//

import UIKit

class MyInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var tableView: UITableView!
    let infoArr = ["내역", "초기화"]
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyInfoTableViewCell
        
        cell.cellLabel.text = infoArr[indexPath[1]]
        
        return cell
        
    }
    
    

  

}
