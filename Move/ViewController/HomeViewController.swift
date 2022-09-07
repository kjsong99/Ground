

import UIKit
import SwiftKeychainWrapper
import Alamofire

class HomeViewController: UIViewController {

    override func viewDidLoad() {

    }
    

    @IBAction func testButton(_ sender: Any) {
        Task{
            do {
                try await postData()
            }catch{
                return
            }
        }
        
        
    }
    
    private func postData() async throws{
        let url =  "\(Bundle.main.url)posts"
        
        let param : Parameters = [
            "title" : "test",
            "content" : "test",
            "user" : 1
        ]
        
        do{
            _ = try await
            AppNetworking.shared.requestJSON(url, type: WriteResponse.self, method: .post, parameters: param)
        }catch{
            return
        }
    }
    
}
