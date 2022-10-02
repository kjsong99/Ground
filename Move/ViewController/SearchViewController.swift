//
//  SearchViewController.swift
//  Move
//
//  Created by 송경진 on 2022/10/02.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    var data = [PostsResponse]()
    
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var keyword: UITextField!
    
    override func viewDidLoad() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        if keyword.text == ""{
            print("검색어를 입력해주세요!")
        }else{
            Task{
                try? await getData(keyword: keyword.text!)
            }
            
        }
    }
    
    func getData(keyword: String) async throws{
        let url =  "\(Bundle.main.url)posts"
        let parameter : Parameters = [
            "_where[_or][0][title_contains]" : keyword,
            "_where[_or][1][content_contains]" : keyword,
            "_where[_or][2][user.username_eq]" : keyword
        ]
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: [PostsResponseElement].self, method: .get, parameters: parameter)

            

            if self.data.count > 0 {
                self.data.removeAll()
            }

            self.data.append(data)
            self.searchTableView.reloadData()
        }catch{
            print(error)
            return
        }
    }
    
}



extension SearchViewController : UITableViewDelegate,  UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count != 0 ? data[0].count : 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "posts", for: indexPath) as! PostsTableViewCell
        cell.titleLabel.text = data[0][indexPath.row].title
        cell.dateLabel.text = Util.setDate(row: indexPath.row, inputDate: data[0][indexPath.row].created_at)
        cell.contentLabel.text = data[0][indexPath.row].content
        cell.nameLabel.text = data[0][indexPath.row].user?.username
        
        return cell
    }
    
    
}
