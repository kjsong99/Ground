//
//  ViewController.swift
//  Move
//
//  Created by 송경진 on 2022/08/04.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
//    @IBOutlet weak var posterImage: UIImageView!
//    @IBOutlet weak var descLabel: UILabel!
//    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var movieView: MovieView!
   
    private var movies : [MovieInfo] = []
    private let baseUrl : String = "https://api.themoviedb.org/3/movie/"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
       //ZButton Tappend
        Task{
            try? await getMovieDetail(movieId: "616037")
            movieView.updateView(movie: movies[0])
        }
    }
    
    
    func getMovieDetail(movieId : String) async throws{
        let url = baseUrl + movieId
        guard let API_KEY = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else{
            return
        }
        let queryString : Parameters = [
            "api_key" : API_KEY,
            "language" : "ko-KR"
        ]
        
        guard let movieData = try? await
                AppNetworking.shared.requestJSON(url, type: Movie.self, method: .get, parameters: queryString) else {
            return
        }
        
        movies.append(movieData.movieToInfo())
      //  movies.append(value)

        
    }
}
    //    @IBAction func ButtonTouched(_ sender: Any) {
////        let url = URL(string: "https://image.tmdb.org/t/p/w500" + info.imagePath)
////        posterImage.image = await loadImage(url: url!)
//
//        Task{
//            try? await fetch()
//
//            let url = URL(string: "https://image.tmdb.org/t/p/w500"+movies[0].posterPath)
//            let image = await loadImage(url: url!)
//
////            self.nameLabel.text = movies[0].title
////            self.descLabel.text = movies[0].overview
////            self.posterImage.image = image
//
//
//        }
//    }
//
//
//
//
//
//    func loadImage(url: URL) async -> UIImage{
//        if let data = try? Data(contentsOf: url){
//            if let image = UIImage(data: data){
//                return image
//            }
//        }
//        return UIImage()
//    }
//
//    private func fetch() async throws{
//        let queryString : Parameters = [
//            "api_key" : Bundle.main.MOVIE_API_KEY,
//            "language" : "ko-KR"
//        ]
//
//      //  let header : HTTPHeaders = [
//         //   "Content-Type" : "application/json"
//        //]
//        let url = "https://api.themoviedb.org/3/movie/616037"
//        let movie = try? await AppNetworking.shared.requestJSON(url, type: Movie.self, method: .get, parameters: queryString)
//        guard let value = movie else { return }
//        movies.append(value)
//    }
//
//
//}


