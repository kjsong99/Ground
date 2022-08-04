//
//  MovieService.swift
//  Move
//
//  Created by 송경진 on 2022/08/04.
//

import Foundation
import Alamofire

struct MovieService{
    static let shared = MovieService()
    
    func getMovieInfo(completionHandler : @escaping (Result<[Movie], Error>) -> Void){
        let queryString : Parameters = [
            "api_key" : Bundle.main.MOVIE_API_KEY,
            "language" : "ko-KR"
        ]
        
        let header : HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let url = "https://api.themoviedb.org/3/movie/616037"
        
    }
}
extension Bundle {
    
    // 생성한 .plist 파일 경로 불러오기
    var MOVIE_API_KEY: String {
        guard let file = self.path(forResource: "KeyInfo", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["TMDB_API_KEY"] as? String else {
            fatalError("TMDB_API_KEY error")
        }
        return key
    }
}

