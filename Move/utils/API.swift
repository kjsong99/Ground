//
//  API.swift
//  Move
//
//  Created by 송경진 on 2022/10/02.
//

import Foundation
import SwiftKeychainWrapper
import Alamofire

class API {
    static var id = UserDefaults.standard.string(forKey: "id")!
    
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
    
    static func getPost(id: Int) async throws -> PostsResponseElement{
        let url =  "\(Bundle.main.url)posts/"+String(id)
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: PostsResponseElement.self, method: .get)
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
            let data = try await AppNetworking.shared.requestJSON(url, type: [PostsResponseElement].self, method: .get, parameters: parameter)
            return data
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func getMyPosts() async throws -> PostsResponse{
        let url =  "\(Bundle.main.url)posts?user.id=" + id
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: [PostsResponseElement].self, method: .get)
            return data
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func createPost(title: String, content: String) async throws{
        let url =  "\(Bundle.main.url)posts"

        let param : Parameters = [
            "title" : title,
            "content" : content,
            "user": id
        ]
        
        do{
            _ = try await
            AppNetworking.shared.requestJSON(url, type: WriteResponse.self, method: .post, parameters: param)
        }catch{
            return
        }
    }
    
    static func deletePost(id: String) async throws{
        let url =  "\(Bundle.main.url)posts/\(id)"
        
        do{
            _ = try await AppNetworking.shared.requestJSON(url, type: WriteResponse.self, method: .delete)
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
            AppNetworking.shared.requestJSON(url, type: WriteResponse.self, method: .put, parameters: param)
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
            
            if (KeychainWrapper.standard.string(forKey: "auth") != nil){
                KeychainWrapper.standard.removeObject(forKey: "auth")
                UserDefaults.standard.removeObject(forKey: "id")
            }
            UserDefaults.standard.set(data.user.id, forKey: "id")
            KeychainWrapper.standard.set(data.jwt, forKey: "auth")
            
        }catch{
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
            
            
            if (KeychainWrapper.standard.string(forKey: "auth") != nil){
                KeychainWrapper.standard.removeObject(forKey: "auth")
                UserDefaults.standard.removeObject(forKey: "id")
            }
            UserDefaults.standard.set(data.user.id, forKey: "id")
            KeychainWrapper.standard.set(data.jwt, forKey: "auth")
            
        }catch{
            print(error)
        }
    }
    
    static func changeName(username : String) async throws {
        let url =  "\(Bundle.main.url)users/" + id
        let param : Parameters = [
            "username" : username
        ]
        
        do{
            
            _ = try await AppNetworking.shared.requestJSON(url, type: UserResponseElement.self, method: .put, parameters: param)

            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func deleteUser() async throws {
        let url =  "\(Bundle.main.url)users/" + id
        do{
            _ = try await
            AppNetworking.shared.requestJSON(url, type: UserResponseElement.self, method: .delete)
        }catch{
            print(error)
            throw error
        }
        
    }
    
    static func changePassword(password : String) async throws {
        let url =  "\(Bundle.main.url)users/" + id
        let param : Parameters = [
            "password" : password
        ]
        
        do{
            
            let _ = try await AppNetworking.shared.requestJSON(url, type: UserResponseElement.self, method: .put, parameters: param)

            
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
    
    static func getUser() async throws -> UserResponseElement {
        let url =  "\(Bundle.main.url)users/" + id
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: UserResponseElement.self, method: .get)
            return data

            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func getUser(id: String) async throws -> UserResponseElement {
        let url =  "\(Bundle.main.url)users/" + id
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: UserResponseElement.self, method: .get)
            return data

            
        }catch{
            print(error)
            throw error
        }
    }
    // MARK - Note
    
    static func getNotes() async throws -> NotesResponse{
      
        let url1 =  "\(Bundle.main.url)notes?send_user.id=" + id
        let url2 =  "\(Bundle.main.url)notes?receive_user.id=" + id
        do{
            let data1 = try await AppNetworking.shared.requestJSON(url1, type: NotesResponse.self, method: .get)
            let data2 = try await AppNetworking.shared.requestJSON(url2, type: NotesResponse.self, method: .get)

            return append(data1: data1, data2: data2).sort()
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func getNotesbyCertainUser(id: Int) async throws -> NotesResponse{
        let url =  "\(Bundle.main.url)notes"
        let parameter : Parameters = [
            "_where[_or][0][user.id_eq]" : id,
            "_where[_or][1][user.id_eq]" : id
        ]
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: NotesResponse.self, method: .get,parameters: parameter)
            
            return data.sort()
            
        }catch{
            print(error)
            throw error
        }
    }
    
    static func sendNote(title: String, content: String,destination: Int) async throws{
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
        let url =  "\(Bundle.main.url)notes/"
        var notes = try await self.getNotesbyCertainUser(id: user)
        for note in notes{
            try await self.deleteNote(id: note.id)
        }
    }
    
  
}
