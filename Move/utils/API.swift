import Foundation
import SwiftKeychainWrapper
import Alamofire

class API {
    static var id : String = ""
    
    static func getId(){
        guard let temp = UserDefaults.standard.string(forKey: "id")else{
            print("getId error")
            return
        }
       id = temp
    }
    
    // MARK - Post
    
    static func getPosts() async throws -> PostsResponse{
        let url =  "\(Bundle.main.url)posts"
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: PostsResponse.self, method: .get)
            
            return data
        }catch{
            print(error)
            throw error
        }
    }
    
    static func getPost(id: Int) async throws -> PostClass{
        let url =  "\(Bundle.main.url)posts/"+id.description
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: PostClass.self, method: .get)
            return data
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func getSearchPosts(keyword: String) async throws -> PostsResponse{
        let url =  "\(Bundle.main.url)posts"
        let parameter : Parameters = [
            "_where[_or][0][title_contains]" : keyword,
            "_where[_or][1][content_contains]" : keyword,
            "_where[_or][2][user.username_eq]" : keyword
        ]
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: PostsResponse.self, method: .get, parameters: parameter)
            return data
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func getMyPosts() async throws -> PostsResponse{
        getId()
        let url =  "\(Bundle.main.url)posts?user.id=" + id
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: PostsResponse.self, method: .get)
            return data
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func createPost(title: String, content: String) async throws{
        getId()
        let url =  "\(Bundle.main.url)posts"

        let param : Parameters = [
            "title" : title,
            "content" : content,
            "user": id
        ]
        
        do{
            _ = try await
            AppNetworking.shared.requestJSON(url, type: PostClass.self, method: .post, parameters: param)
        }catch{
            return
        }
    }
    
    static func deletePost(id: String) async throws{
        let url =  "\(Bundle.main.url)posts/\(id)"
        
        do{
            _ = try await AppNetworking.shared.requestJSON(url, type: PostClass.self, method: .delete)
        }catch{
            return
        }
        
        
    }
    
    static func modify(title: String, content: String, id: Int) async throws{
        let url =  "\(Bundle.main.url)posts/" + id.description
        let param : Parameters = [
            "title" : title,
            "content" : content
        ]
        
        do{
            _ = try await
            AppNetworking.shared.requestJSON(url, type: PostClass.self, method: .put, parameters: param)
        }catch{
            throw error
        }
    }
    
    // MARK - User
    
    static func isNameExist(name : String) async throws -> Bool{
        //        let url =  "\(Bundle.main.url)users?username_eq=" + name
        let url =  "\(Bundle.main.url)users?username_eq=" + name
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: UserResponse.self, method: .get)
            if data.count == 0 {
                return false
            }
            
        }catch{
            throw error
        }
        return true
        
    }
    
    static func isEmailExist(email : String) async throws -> Bool{
        let url =  "\(Bundle.main.url)users?email_eq=" + email
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: UserResponse.self, method: .get)
            
            if data.count == 0 {
                return false
            }
            
        }catch{
            print(error)
        }
        return true
        
    }
    
    static func signIn(email: String, password: String) async throws{
        
        let url = "\(Bundle.main.url)auth/local"
        let param = [
            "identifier" : email,
            "password" : password
        ]
        
        do{
            let data = try await
            AppNetworking.shared.requestJSON(url, type: RegisterResponse.self, method: .post, parameters: param)
            UserDefaults.standard.set(data.user.id.description, forKey: "id")
            KeychainWrapper.standard.set(data.jwt, forKey: "auth")
        
            
        }catch{
            print(error)
            throw error
        }
        
    }
    
    static func signUp(email: String, password: String, username: String, gender: String, birth: String) async throws{
        let url = "\(Bundle.main.url)auth/local/register"
        let param : Parameters =  [
            "username" : username,
            "email" : email,
            "password" : password,
            "gender" : gender,
            "birth" : birth
        ]
        
        do{
            let data = try await
            AppNetworking.shared.requestJSON(url, type: RegisterResponse.self, method: .post, parameters: param)
            UserDefaults.standard.set(data.user.id.description, forKey: "id")
            KeychainWrapper.standard.set(data.jwt, forKey: "auth")
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func changeName(username : String) async throws {
        getId()
        let url =  "\(Bundle.main.url)users/" + id
        let param : Parameters = [
            "username" : username
        ]
        
        do{
            
            _ = try await AppNetworking.shared.requestJSON(url, type: User.self, method: .put, parameters: param)

            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func deleteUser() async throws {
        getId()
        let url =  "\(Bundle.main.url)users/" + id
        do{
            _ = try await
            AppNetworking.shared.requestJSON(url, type: User.self, method: .delete)
        }catch{
            print(error)
            throw error
        }
        
    }
    
    static func changePassword(password : String) async throws {
        getId()
        let url =  "\(Bundle.main.url)users/" + id
        let param : Parameters = [
            "password" : password
        ]
        
        do{
            
            let _ = try await AppNetworking.shared.requestJSON(url, type: User.self, method: .put, parameters: param)

            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func currentPassword(password : String) async throws -> Bool{
        do{
            let username = try await getUser().username
            
            let url = "\(Bundle.main.url)auth/local"
            let param = [
                "identifier" : username,
                "password" : password
            ]
            
            let data = try await
                    AppNetworking.shared.requestJSON(url, type: RegisterResponse.self, method: .post, parameters: param)
            
            if data.jwt.isEmpty{
                return false
            }else{
                return true
            }
            
        }catch{
            print(error)
            throw error
        }
        
    }
    
    
    // MARK - Heart
    
    static func deleteHeart(id : String) async throws {
        let url =  "\(Bundle.main.url)hearts/" + id
        do{
            _ = try await
            AppNetworking.shared.requestJSON(url, type: HeartResponseElement.self, method: .delete)
        }catch{
            print(error)
            throw error
        }
        
    }
    
    static func getCountHeart(post : String) async throws -> Int{
        let url =  "\(Bundle.main.url)hearts?post.id=" + post
        
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: HeartResponse.self, method: .get)
            return data.count
            
            
        }catch{
            print(error)
            throw error
        }
    }
    

    
    static func checkHeart(post : String) async throws -> Int? {
        getId()
        let url =  "\(Bundle.main.url)hearts"
        let parameter : Parameters = [
            "_where[_and][0][post_eq]" : post,
            "_where[_and][1][user_eq]" : id
        ]
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: HeartResponse.self, method: .get, parameters: parameter)
    
            if data.count == 0 {
                return 0
            }else{
                return data[0].id
            }
            
          
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func createHeart(post : String) async throws -> Int{
        getId()
        let url =  "\(Bundle.main.url)hearts"
        let param : Parameters = [
            "post" : post,
            "user" : id
        ]
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: HeartResponseElement.self, method: .post, parameters: param)
            return data.id
        }catch{
            print(error)
            throw error
        }
        
    }
    
    // MARK - Star
    static func checkStar(post : String) async throws -> Int? {
        getId()
        let url =  "\(Bundle.main.url)stars"
        let parameter : Parameters = [
            "_where[_and][0][post.id_eq]" : post,
            "_where[_and][1][user.id_eq]" : id
        ]
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: StarResponse.self, method: .get, parameters: parameter)
    
            if data.count == 0 {
                return 0
            }else{
                return data[0].id
            }
            
          
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func createStar(post : String) async throws -> Int{
        getId()
        let url =  "\(Bundle.main.url)stars"
        let param : Parameters = [
            "post" : post,
            "user" : id
        ]
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: StarResponseElement.self, method: .post, parameters: param)
            return data.id
        }catch{
            print(error)
            throw error
        }
        
    }
    
    static func deleteStar(id : String) async throws{
        getId()
        let url =  "\(Bundle.main.url)stars/" + id
        do{
            _ = try await
            AppNetworking.shared.requestJSON(url, type: StarResponseElement.self, method: .delete)
        }catch{
            print(error)
            throw error
        }
    }
    
    static func getStarPosts() async throws  -> StarResponse{
        getId()
        let url =  "\(Bundle.main.url)stars?user=" + id
        do{
            let data = try await
            AppNetworking.shared.requestJSON(url, type: StarResponse.self, method: .get)
            return data
        }catch{
            print(error)
            throw error
        }
    
    }
    
    static func getUser() async throws -> User {
        getId()
        let url =  "\(Bundle.main.url)users/" + id
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: User.self, method: .get)
            return data

            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func getUser(id: String) async throws -> User {
        let url =  "\(Bundle.main.url)users/" + id
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: User.self, method: .get)
            return data

            
        }catch{
            print(error)
            throw error
        }
    }
    
    // MARK - Note
    
    static func getNotes() async throws -> NotesResponse{
        getId()
        let url1 =  "\(Bundle.main.url)notes?send_user.id=" + id
        let url2 =  "\(Bundle.main.url)notes?receive_user.id=" + id
        do{
            let data1 = try await AppNetworking.shared.requestJSON(url1, type: NotesResponse.self, method: .get)
            let data2 = try await AppNetworking.shared.requestJSON(url2, type: NotesResponse.self, method: .get)

            return getChats(data1: data1.sort().uniques(by:\.receive_user), data2: data2.sort().uniques(by: \.send_user)).sort()
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func getNotesbyCertainUser(user: Int) async throws -> NotesResponse{
        getId()
        let url =  "\(Bundle.main.url)notes"
        let parameter1 : Parameters = [
            "_where[_and][0][send_user.id_eq]" : user,
            "_where[_and][1][receive_user.id_eq]" : id
        ]
        
        let parameter2 : Parameters = [
            "_where[_and][0][send_user.id_eq]" : id,
            "_where[_and][1][receive_user.id_eq]" : user
        ]
        
        do{
            let data1 = try await AppNetworking.shared.requestJSON(url, type: NotesResponse.self, method: .get,parameters: parameter1)
         
            let data2 = try await AppNetworking.shared.requestJSON(url, type: NotesResponse.self, method: .get,parameters: parameter2)
        
            return  append(data1: data1.sort(), data2: data2.sort()).sort()
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func sendNote(title: String, content: String,destination: Int) async throws{
        getId()
        let url =  "\(Bundle.main.url)notes"
        let parameter : Parameters = [
            "title" : title,
            "content" : content,
            "send_user": id,
            "receive_user": destination
        ]
        
        do{
            let _ = try await AppNetworking.shared.requestJSON(url, type: NotesResponse.self, method: .post,parameters: parameter)
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func deleteNote(id: Int) async throws{
        let url =  "\(Bundle.main.url)notes/" + id.description

        do{
            let _ = try await AppNetworking.shared.requestJSON(url, type: NotesResponse.self, method: .delete)
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func deleteAll(user: Int) async throws{
        let notes = try await self.getNotesbyCertainUser(user: user)
        for note in notes{
            try await self.deleteNote(id: note.id)
        }
    }
    
  
}
