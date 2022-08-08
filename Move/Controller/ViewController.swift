import UIKit
import Alamofire


class ViewController: UIViewController {
    
    private var movies : [Movie] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        Task{

            try await fetch()
            self.collectionView.reloadData()
        }
        

        
        
        // Do any additional setup after loading the view.
    }
    private func fetch()  async throws{
    //    guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
    //        return
    //    }
        guard let API_KEY = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else{
            throw DataError.typeError
        }
        let queryString : Parameters = [
            "api_key" : API_KEY,
            "language" : "ko-KR",
            "with_original_language" : "ko",
            "page" : 2
        ]
        
        guard let result = try? await AppNetworking.shared.requestJSON("https://api.themoviedb.org/3/movie/popular", type: MovieResponse.self, method: .get, parameters: queryString) else {
            throw DataError.empty
        }
        print(result.results.count)
        movies =  result.results

    }
    
    func loadImage(url: URL) -> UIImage{
        if let data = try? Data(contentsOf: url){
            if let image = UIImage(data: data){
                return image
            }
        }
        return UIImage()
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



extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomMovieCell
//        //cell.label.text = array[indexPath.row]
//        let url = URL(string: "https://t1.daumcdn.net/movie/72cfc7293390c63db16779b67097d8703d2a5628")
//        let data = try? Data(contentsOf: url!)
//        print("cell count : \(movies[0].title)")
//        cell.movieImage.image = UIImage(data: data!)
        cell.movieTitle.text = movies[indexPath.row].title
        let urlString = "https://image.tmdb.org/t/p/w500/" + movies[indexPath.row].posterPath
        let url = URL(string: urlString)
//
//        let data = Data(contentsOf: url)
//        cell.movieImage.image = UIImage(data: data)
        cell.movieImage.image = loadImage(url: url!)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    
    
}
