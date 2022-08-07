import UIKit
import Alamofire


class ViewController: UIViewController {
    
    private var movies : [MovieInfo] = []
  
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
}
    
    //    @IBAction func buttonTapped(_ sender: Any) {
    //       //ZButton Tappend
    //        Task{
    //            try? await getMovieDetail(movieId: "616037")
    //            movieView.updateView(movie: movies[0])
    //        }
    //    }
    
  
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
    func loadImage(url: URL) async -> UIImage{
        if let data = try? Data(contentsOf: url){
            if let image = UIImage(data: data){
                return image
            }
        }
        return UIImage()
    }
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

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomMovieCell
        //cell.label.text = array[indexPath.row]
        let url = URL(string: "https://t1.daumcdn.net/movie/72cfc7293390c63db16779b67097d8703d2a5628")
        let data = try? Data(contentsOf: url!)
        cell.movieImage.image = UIImage(data: data!)
        cell.movieTitle.text = "movie \(indexPath.row.description)"
        return cell
    }
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
  
    
    
}
