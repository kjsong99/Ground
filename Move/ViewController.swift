//
//  ViewController.swift
//  Move
//
//  Created by 송경진 on 2022/08/04.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ButtonTouched(_ sender: Any) async {
      
        //let url = URL(string: "https://image.tmdb.org/t/p/w500" + info.imagePath)
       // posterImage.image = await loadImage(url: url!)
    }
    
    
    
    
    func loadImage(url: URL) async -> UIImage{
        if let data = try? Data(contentsOf: url){
            if let image = UIImage(data: data){
                return image
            }
        }
        return UIImage()
    }
    
}

struct MovieInfo{
    var title : String
    var describe : String
    var imagePath : String
}
