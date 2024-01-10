import SwiftUI
import Alamofire

//getリクエストの返り値の型定義
struct ApiAlbum: Codable, Equatable {
    var id:Int
    var album_name: String
    var album_data: String
    var album_latitude:  Double?
    var album_longitude: Double?
    var updated_at: String
}

//ローカルホスト
//var apiAlbumEndPoint = "http://localhost:4242/api/v1/albums"
//Heroku
var apiAlbumEndPoint = "https://drawing-traveler-7a488b236b7c.herokuapp.com/api/v1/albums"
//render
//var apiAlbumEndPoint = "https://drawing-traveler-server.onrender.com/api/v1/albums"

//getメソッド
func apiAlbumGetRequest() async -> [ApiAlbum] {
    await withCheckedContinuation { continuation in
        AF.request(apiAlbumEndPoint, method: .get)
            .response{ response in
                let decoder = JSONDecoder()
                do {
                    let albums = try decoder.decode([ApiAlbum].self, from: response.data!)
                    continuation.resume(returning: albums)
                    print("GET albums type : \(type(of:albums))")
                } catch {
                    print("Error decoding JSON: \(error)")
                    continuation.resume(throwing: error as! Never)
                }
            }
    }
}
//postメソッド
// [String:Any]にしても、緯度経度はDBに登録できない。。。涙
func apiAlbumPostRequest(reqBody : [String: Any]) async -> [String: Any] {
    var decodedMessage : [String: Any] = [:]
    return await withCheckedContinuation { continuation in
        AF.request(apiAlbumEndPoint, method: .post, parameters: reqBody)
            .response{ response in
                let decoder = JSONDecoder()
                do {
                    let message = try decoder.decode(ResponseMessage.self, from: response.data!)
                    decodedMessage["message"] = message.message
                    continuation.resume(returning: decodedMessage)
                } catch {
                    print("Error decoding JSON: \(error)")
                    continuation.resume(throwing: error as! Never)
                }
            }
    }
}
//deleteメソッド
func apiAlbumDeleteRequest(albumID : Int) async -> [String: Any] {
    var decodedMessage : [String: Any] = [:]
    return await withCheckedContinuation { continuation in
        AF.request("\(apiAlbumEndPoint)/\(albumID)", method: .delete)
            .response{ response in
                let decoder = JSONDecoder()
                do {
                    let message = try decoder.decode(ResponseMessage.self, from: response.data!)
                    decodedMessage["message"] = message.message
                    continuation.resume(returning: decodedMessage)
                } catch {
                    print("Error decoding JSON: \(error)")
                    continuation.resume(throwing: error as! Never)
                }
            }
    }
}
//updateメソッド
func apiAlbumUpdateReqest(reqBody : [String: String],albumID : Int) async -> [String: Any] {
    var decodedMessage : [String: Any] = [:]
    return await withCheckedContinuation { continuation in
        AF.request("\(apiAlbumEndPoint)/\(albumID)", method: .patch, parameters: reqBody)
            .response{ response in
                let decoder = JSONDecoder()
                do {
                    let message = try decoder.decode(ResponseMessage.self, from: response.data!)
                    decodedMessage["message"] = message.message
                    continuation.resume(returning: decodedMessage)
                } catch {
                    print("Error decoding JSON: \(error)")
                    continuation.resume(throwing: error as! Never)
                }
            }
    }
}
