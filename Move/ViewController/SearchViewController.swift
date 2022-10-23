//
//  SearchViewController.swift
//  Move
//
//  Created by 송경진 on 2022/10/02.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    
    // MARK - Variable
    
    var postsData : PostsResponse?
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var keyword: UITextField!
    
    // MARK - override
    
    override func viewWillAppear(_ animated: Bool) {
        Task{
            do{
                postsData = try await API.getSearchPosts(keyword: keyword.text ?? "")
                self.searchTableView.reloadData()
            }catch{
                throw error
            }
         
        }
    }
    
    override func viewDidLoad() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    
    
    // MARK - method
    
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        if keyword.text == ""{
            let alert = UIAlertController(title: nil, message: "검색어를 입력하세요!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            Task{
                do{
                    postsData = try await API.getSearchPosts(keyword: keyword.text ?? "")
                    self.searchTableView.reloadData()
                }catch{
                    throw error
                }
             
            }
            
        }
    }
    
 
    
}

// MARK - extension

extension SearchViewController : UITableViewDelegate,  UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData?.count ?? 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchPosts", for: indexPath) as! PostsTableViewCell
        if let data = postsData{
            
            cell.titleLabel.text = data[indexPath.row].title
            cell.dateLabel.text = Util.setDate(row: indexPath.row, inputDate: data[indexPath.row].createdAt)
            cell.contentLabel.text = data[indexPath.row].content
            cell.nameLabel.text = data[indexPath.row].user?.username
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

