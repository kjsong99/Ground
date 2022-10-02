//
//  ViewController.swift
//  Move
//
//  Created by 송경진 on 2022/08/09.
//

import UIKit
import Alamofire
import Foundation

class BoardViewController: UIViewController{
    
    // MARK - Variable
    
    var postsData = [PostsResponse]()
    @IBOutlet var postsTableView: UITableView!
    
    
    
    // MARK - Override
    override func viewDidLoad() {
        
        Task{
            postsTableView.dataSource = self
            postsTableView.delegate = self
            try? await getData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show"{
            let vc : WriteViewController = segue.destination as! WriteViewController
            vc.delegate = self
        }
        
    }
   
    
    // MARK - Method
    
    

    
    
    
    
    
    func getData() async throws{
        let url =  "\(Bundle.main.url)posts"
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: [PostsResponseElement].self, method: .get)
            
            
            if self.postsData.count > 0 {
                self.postsData.removeAll()
            }
            self.postsData.append(data)
            self.postsTableView.reloadData()
        }catch{
            print(error)
            return
        }
    }
    
    
}

// MARK - EXTENSION

extension BoardViewController : BoardDelegate{
    func refreshBoard() {
        Task{
            do{
                print("refresh")
                try await  getData()
                
            }catch{
                print(error)
            }
        }
        
    }
}


extension BoardViewController : UITableViewDelegate, UITableViewDataSource{
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData.count != 0 ? postsData[0].count : 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "posts", for: indexPath) as! PostsTableViewCell
        cell.titleLabel.text = postsData[0][indexPath.row].title
        cell.dateLabel.text = Util.setDate(row: indexPath.row, inputDate: postsData[0][indexPath.row].created_at)
        cell.contentLabel.text = postsData[0][indexPath.row].content
        cell.nameLabel.text = postsData[0][indexPath.row].user?.username
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
        postVC.id = postsData[0][indexPath.row].id
        postVC.delegate = self
        
        self.navigationController?.pushViewController(postVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            Task{
                let id = postsData[0][indexPath.row].id.description
                try? await deletePost(id: id)
                try? await getData()
            }
            
        }
    }
    
}



extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func year() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: self)
    }
    
    func month() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter.string(from: self)
    }
    
    func day() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    
    func hour() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: self)
    }
    
    func min() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter.string(from: self)
    }
    
    func stringUTC(format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}

extension String{
    func date(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    func dateUTC(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
