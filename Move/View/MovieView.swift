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
    
//    func updateView(movie: MovieInfo){
//        Task{
//            try? await movieImage.load(imagePath: movie.imagePath)
//            self.titleLabel.text = movie.title
//            self.overviewLabel.text = movie.overview
//            
//        }
//    }
    
    
}

extension UIImageView {
    func load(imagePath: String) async throws {
        guard let imageBaseUrl : String = Bundle.main.object(forInfoDictionaryKey: "IMAGE_URL") as? String else {
            return
        }
        guard let url = URL(string: imageBaseUrl + imagePath) else {
            return
        }
        
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}


