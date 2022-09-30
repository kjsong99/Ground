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
    
    
    
    override func viewDidLoad() {
        //        var current_year_string = Date().string(format: "yyyy")
        //        var current_month_string = Date().string(format: "MM")
        //        var current_day_string = Date().string(format: "dd")
        //        var current_hour_string = Date().string(format: "HH")
        
        
        Task{
            postsTableView.dataSource = self
            postsTableView.delegate = self
            try? await getData()
        }
        
        
        
        
    }
    
    
    // MARK - Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show"{
            let vc : WriteViewController = segue.destination as! WriteViewController
            vc.delegate = self
        }
        
    }
    
    func deletePost(id: String) async throws{
        let url =  "\(Bundle.main.url)posts/\(id)"
        
        do{
            _ = try await AppNetworking.shared.requestJSON(url, type: WriteResponse.self, method: .delete)
        }catch{
            return
        }
    }
    
    func getDate(str: String) throws -> Date{
        guard let result = str.dateUTC(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")else{
            throw ErrorMessage.typeError
        }
        return result
        
    }
    
    
    
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

extension BoardViewController : NotificationDelegate{
    func refresh() {
        Task{
            try? await  getData()
        }
        
    }
}

extension BoardViewController : UITableViewDelegate, UITableViewDataSource{
 
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData.count != 0 ? postsData[0].count : 0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
        postVC.id = postsData[0][indexPath.row].id
        
        self.navigationController?.pushViewController(postVC, animated: true)
        //        postVC.modalPresentationStyle = .fullScreen
        //        self.present(postVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current_year_string = Date().year()
        let current_month_string = Date().month()
        let current_day_string = Date().day()
        let current_hour_string = Date().hour()
        
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "posts", for: indexPath) as! PostsTableViewCell
        cell.titleLabel.text = postsData[0][indexPath.row].title
        
        do{
            let date = try getDate(str: postsData[0][indexPath.row].created_at)
            if date.year() == current_year_string &&
                date.month() == current_month_string &&
                date.day() == current_day_string{
                if date.hour() == current_hour_string {
                    cell.dateLabel.text = "방금전"
                }else{
                    cell.dateLabel.text = String(Int(current_hour_string)! - Int(date.hour())!) + "시간 전"
                }
            }else{
                cell.dateLabel.text = date.month() + "월" + date.day() + "일"
            }
        }catch{
            print(error)
        }
        
        
        
        
        
        
        
        
        return cell
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
    
    
}

extension String{
    func date(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
