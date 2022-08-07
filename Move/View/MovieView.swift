//
//  MovieView.swift
//  Move
//
//  Created by 송경진 on 2022/08/06.
//

import Foundation
import UIKit

final class MovieView : UIView{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    let imageBaseUrl : String = "https://image.tmdb.org/t/p/w500/"
    

    
    func updateView(movie: MovieInfo){
        guard let url : URL = URL(string: imageBaseUrl+movie.imagePath) else {
            return
        }
        Task{
            try? await movieImage.load(url: url)
            self.titleLabel.text = movie.title
            self.overviewLabel.text = movie.overview
            
        }
      
    
//        self.movieImage.image = image
    }
    
    
}

extension UIImageView {
    func load(url: URL) async throws {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
