//
//  ViewController.swift
//  Move
//
//  Created by 송경진 on 2022/08/04.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    private var movies : [Movie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }
    
    @IBAction func ButtonTouched(_ sender: Any) {
//        let url = URL(string: "https://image.tmdb.org/t/p/w500" + info.imagePath)
//        posterImage.image = await loadImage(url: url!)
        
        Task{
            try? await fetch()
            
            let url = URL(string: "https://image.tmdb.org/t/p/w500"+movies[0].posterPath)
            let image = await loadImage(url: url!)
            
            self.nameLabel.text = movies[0].title
            self.descLabel.text = movies[0].overview
            self.posterImage.image = image
            
            
        }
    }
    

    
    
    
    func loadImage(url: URL) async -> UIImage{
        if let data = try? Data(contentsOf: url){
            if let image = UIImage(data: data){
                return image
            }
        }
        return UIImage()
    }
    
    private func fetch() async throws{
        let queryString : Parameters = [
            "api_key" : Bundle.main.MOVIE_API_KEY,
            "language" : "ko-KR"
        ]
        
      //  let header : HTTPHeaders = [
         //   "Content-Type" : "application/json"
        //]
        let url = "https://api.themoviedb.org/3/movie/616037"
        let movie = try? await AppNetworking.shared.requestJSON(url, type: Movie.self, method: .get, parameters: queryString)
        guard let value = movie else { return }
        movies.append(value)
    }
    
  
    
}

struct MovieInfo{
    var title : String
    var describe : String
    var imagePath : String
}

extension Bundle {
    
    // 생성한 .plist 파일 경로 불러오기
    var MOVIE_API_KEY: String {
        guard let file = self.path(forResource: "KeyInfo", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["TMDB_API_KEY"] as? String else {
            fatalError("TMDB_API_KEY error")
        }
        return key
    }
}
