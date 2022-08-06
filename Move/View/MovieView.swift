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
    

    
    func updateView(movie: Movie, image: UIImage){
        self.titleLabel.text = movie.title
        self.overviewLabel.text = movie.overview
        self.movieImage.image = image
    }
    
    
}
