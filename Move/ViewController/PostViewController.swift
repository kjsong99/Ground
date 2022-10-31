import UIKit

class PostViewController: UIViewController{
    
    // MARK - PROPERTY
    var id : Int = 0
    var postData : PostClass?
    var heartChecked : Bool = false
    var bookmarkChecked : Bool = false
    var heartId = 0
    var bookmarkId = 0
    
    // MARK - OUTLET
    @IBOutlet var contentView: UIScrollView!
    @IBOutlet var heartButton: UIButton!
    @IBOutlet var bookmarkButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var userLabel: UILabel!
    
    @IBAction func bookmarkBtnTapped(_ sender: Any) {
        Task{
            do{
                if bookmarkChecked {
                    //하트 해제 로직
                    try await API.deleteStar(id: bookmarkId.description)
                    bookmarkChecked = false
                    bookmarkId = 0
                    bookmarkButton.getEmptyBookmarkBtn()
                    
                }else{
                    //북마크 클릭 로직
                    bookmarkId = try await API.createStar(post: id.description)
                    
                    bookmarkChecked = true
                    bookmarkButton.getFilledBookmarkBtn()
                    
                    
                }
            }
            
        }
    }
    
    @IBAction func heartBtnTapped(_ sender: Any) {
        Task{
            do{
                if heartChecked {
                    //하트 해제 로직
                    try await API.deleteHeart(id: heartId.description)
                    heartChecked = false
                    heartId = 0
                    heartButton.getEmptyHeartBtn()
                    //                    let image = UIImage(systemName: "heart")
                    //                    heartButton.setImage(image, for: .normal)
                }else{
                    //하트 클릭 로직
                    heartId = try await API.createHeart(post: id.description)
                    
                    heartChecked = true
                    //                    let image = UIImage(systemName: "heart.fill")
                    //                    heartButton.tintColor = UIColor.red
                    //
                    //                    heartButton.setImage(image, for: .normal)
                    heartButton.getFilledHeartBtn()
                    
                    
                }
            }
            
        }
        
    }
    
    @IBAction func showMoreButton(_ sender: Any){
        let actionSheet = UIAlertController(title: "글메뉴", message: nil, preferredStyle: .actionSheet)
        //취소 버튼 - 스타일(cancel)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        //여기서 글쓴이인지 확인
        API.getId()
        if API.id == postData!.user.id.description{
            actionSheet.addAction(UIAlertAction(title: "수정", style: .default, handler: {(ACTION:UIAlertAction) in
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "WriteVC") as? WriteViewController{
                    //
                    vc.modifyPost = self.postData!
                    //
                    self.show(vc, sender: self)
                }
            }))
            
            
            
            actionSheet.addAction(UIAlertAction(title: "삭제", style: .default, handler: {(ACTION:UIAlertAction) in
                let sheet = UIAlertController(title: nil, message: "정말 삭제하겠습니까?", preferredStyle: .alert)
                sheet.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
                    Task{
                        do{
                            try await API.deletePost(id: self.id.description)
                            
                            self.tabBarController?.selectedIndex = 0
                            self.navigationController?.popToRootViewController(animated: false)
                        }catch{
                            print(error)
                            throw error
                        }
                        
                    }
                    
                    
                }))
                sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {_ in
                }))
                self.present(sheet,animated: true)
                
                
            }))
            self.present(actionSheet,animated: true)
            
        }else{
            //글쓴이가 아닐때
            //쪽지, 신고 등등?
            
            actionSheet.addAction(UIAlertAction(title: "쪽지", style: .default, handler: {(ACTION:UIAlertAction) in
                //쪽지 write 뷰로 이동
                //수신자 아이디 property로
            }))
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK - OVERRIDE
    
    override func viewWillAppear(_ animated: Bool) {
        viewInit()
        
    }
    
    // MARK - METHOD
    
    func viewInit(){
        Task{
            do{
                postData = try await API.getPost(id: id)
                heartId = try await API.checkHeart(post: id.description) ?? 00
                bookmarkId = try await API.checkStar(post: id.description) ?? 00
                setData(heartId: heartId, bookmarkId: bookmarkId)
            }catch{
                print(error)
                throw error
            }
        }
    }
    
    func setData(heartId : Int , bookmarkId : Int){
        if let post = postData {
            
            titleLabel.text = post.title
            contentLabel.text = post.content
            userLabel.text = post.user.username
            
            
            if let date = post.createdAt.dateUTC(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"){
                let str = date.string(format: "MM/dd HH:mm")
                dateLabel.text = str
            }
            
            contentLabel.sizeToFit()
            contentView.sizeToFit()
            
            
            if bookmarkId != 0 {
                bookmarkChecked = true
                bookmarkButton.getFilledBookmarkBtn()
            }
            if heartId != 0{
                heartChecked = true
                heartButton.getFilledHeartBtn()
                
                
            }
        }
    }
}
    

// MARK - EXTENSION
extension UIButton{
    func getEmptyHeartBtn() {
        self.setImage(UIImage(systemName: "heart"), for: .normal)
        self.tintColor = UIColor.darkGray
        
    }
    
    func getFilledHeartBtn() {
        self.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        self.tintColor = UIColor.red
        
        
    }
    
    func getEmptyBookmarkBtn() {
        self.setImage(UIImage(systemName: "star"), for: .normal)
        self.tintColor = UIColor.darkGray
        
    }
    
    func getFilledBookmarkBtn() {
        self.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.tintColor = UIColor.systemYellow
        
        
    }
}


