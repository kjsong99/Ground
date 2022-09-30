
import UIKit
import SwiftKeychainWrapper
import Kingfisher

class SettingViewController: UIViewController {
    
    override func viewWillLayoutSubviews() {
      // createCircleImageView(imageView: imageView)
    }
    
    override func viewDidLoad() {
//        let image = UIImage(systemName:"circle.dashed")
//        let url = URL(string: Bundle.main.url+"uploads/astronaut_outer_open_space_planet_earth_stars_provide_background_erforming_space_planet_earth_sunrise_sunset_our_home_iss_elements_this_image_furnished_by_nasa_150455_16829_7b571df095.jpeg")
        
       // imageView.kf.setImage(with: url, placeholder: image)
    }
    
    func createCircleImageView(imageView: UIImageView){
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }
    
    
    
    @IBAction func SignOutBtnTapped(_ sender: Any) {
        print("sign out")
        KeychainWrapper.standard.removeObject(forKey: "auth")
        UserDefaults.standard.removeObject(forKey: "id")
        
        let sb = UIStoryboard(name: "Login", bundle: nil)
        guard let vc = sb.instantiateInitialViewController() else { return }
        
        
        
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true)
    }
    
    
    
    

}
