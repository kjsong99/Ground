
import UIKit
import SwiftKeychainWrapper
import Kingfisher

class SettingViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    var menuImage = ["square.and.pencil", "paperplane", "bookmark", "person.crop.circle.badge.xmark" ]
    var menuLabel = ["내가 쓴 글", "쪽지함",  "북마크", "회원 탈퇴"]
    override func viewWillLayoutSubviews() {
      // createCircleImageView(imageView: ima
        
    }
    
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        setName()
//        let image = UIImage(systemName:"circle.dashed")
//        let url = URL(string: Bundle.main.url+"uploads/astronaut_outer_open_space_planet_earth_stars_provide_background_erforming_space_planet_earth_sunrise_sunset_our_home_iss_elements_this_image_furnished_by_nasa_150455_16829_7b571df095.jpeg")
        
       // imageView.kf.setImage(with: url, placeholder: image)
    }
    
    func setName(){
        Task{
            do{
                nameLabel.text = try await API.getUser(id: UserDefaults.standard.string(forKey: "id")!).username
            }
        }
    }
    
    func createCircleImageView(imageView: UIImageView){
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }
    
    @IBAction func nameChangeBtnTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NameChangeVC") as? NameChangeViewController
        
        vc?.delegate = self
        self.show(vc!, sender: self)
    }
    

    
    @IBAction func profileEditBtnTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileEditVC") as? ProfileEditViewController
        
        self.show(vc!, sender: self)
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        
            KeychainWrapper.standard.removeObject(forKey: "auth")
            UserDefaults.standard.removeObject(forKey: "id")
            
            let sb = UIStoryboard(name: "Login", bundle: nil)
            guard let vc = sb.instantiateInitialViewController() else { return }
            
            
            
            vc.modalPresentationStyle = .fullScreen
            
            self.present(vc, animated: true)
    }
    
    
    

}

extension SettingViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuLabel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as?
                    SettingCollectionViewCell else {
           
                return SettingCollectionViewCell()
            }
        cell.menuImage.image = UIImage(systemName: menuImage[indexPath.row])
        cell.menuLabel.text = menuLabel[indexPath.row]
     
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if menuLabel[indexPath.row] == "회원 탈퇴"{
            let alert = UIAlertController(title: "정말 탈퇴하겠습니까?", message: "삭제된 계정의 데이터는 복구할 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "예", style: .default, handler: { _ in
                Task{
                    do{
                        try await API.deleteUser(id: UserDefaults.standard.string(forKey: "id")!)
                        KeychainWrapper.standard.removeObject(forKey: "auth")
                        UserDefaults.standard.removeObject(forKey: "id")
                        
                        let sb = UIStoryboard(name: "Login", bundle: nil)
                        guard let vc = sb.instantiateInitialViewController() else { return }
                        
                        
                        
                        vc.modalPresentationStyle = .fullScreen
                        
                        self.present(vc, animated: true)
                    }catch{
                        print(error)
                        throw error
                    }
                }
                
            }))
            
            self.present(alert, animated: true)
        }
//        else if menuLabel[indexPath.row] == "비밀번호 변경"{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC")
//            self.show(vc!, sender: self)
//        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
 
 
   
    
    
}

extension SettingViewController : SettingDelegate {
    func refresh() {
        setName()
    }
    
    
}
