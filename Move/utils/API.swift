//
//  API.swift
//  Move
//
//  Created by 송경진 on 2022/10/02.
//

import Foundation
import Alamofire

class API {
    static func getPosts() async throws -> PostsResponse{
        let url =  "\(Bundle.main.url)posts"
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: PostsResponse.self, method: .get)
            
            return data
        }catch{
            throw error
        }
    }
    
    static func getPost(id: Int) async throws -> PostsResponseElement{
        let url =  "\(Bundle.main.url)posts/"+String(id)
        
        do{
            let data = try await AppNetworking.shared.requestJSON(url, type: PostsResponseElement.self, method: .get)
           return data
            
        }catch{
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
            throw error
        }
    }
    
    static func createPost(title: String, content: String) async throws{
        let url =  "\(Bundle.main.url)posts"
        guard let id = UserDefaults.standard.string(forKey: "id") else {
            return
        }
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
}
