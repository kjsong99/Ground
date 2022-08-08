import Foundation
import UIKit
import Alamofire
class MovieDetailViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func getMovieDetail(movieId : String) async throws{
//        guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
//            return
//        }
//        guard let API_KEY = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else{
//            return
//        }
//        let queryString : Parameters = [
//            "api_key" : API_KEY,
//            "language" : "ko-KR"
//        ]
        
//        guard let movieData = try? await
//                AppNetworking.shared.requestJSON(url + movieId, type: Movie.self, method: .get, parameters: queryString) else {
//            return
//        }
        // movieData.movieToInfo()

         //MovieInfo를 뷰에 뿌려주면 됨
    }
}
