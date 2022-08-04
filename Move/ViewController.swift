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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ButtonTouched(_ sender: Any) {
        getMovieById()
    }
    
    func getMovieById() {
        let url = "https://api.themoviedb.org/3/movie/616037"
        // [http 요청 헤더 지정]
        let header : HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        // [http 요청 파라미터 지정 실시]
        let queryString : Parameters = [
            "api_key" : "test",
            "language" : "ko-KR"
        ]
        
        AF.request(url, method: .get, parameters: queryString, headers: header).responseDecodable(of: Movie.self){response in
            
            switch response.result{
            case .success(let value):
                guard let movie = response.value else { return }
                self.nameLabel.text = movie.title
                self.descLabel.text = movie.overview
                self.descLabel.sizeToFit()
                let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + movie.posterPath)
                self.posterImage.load(url: imageUrl!)
        
            case .failure(let error):
                print(error)
                break;
            }
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
