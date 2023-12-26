import SwiftUI
import Alamofire

//getリクエストの返り値の型定義
struct ApiAlbum: Codable {
    var id:Int
    var album_name: String
    var album_data : String
    var updated_at : String
}
//post・patch・deleteリクエストの返り値の型定義
//struct ResponseMessage: Codable {
//    var message:String
//}
//ローカルホスト
//var apiAlbumEndPoint = "http://localhost:4242/api/v1/albums"
//Heroku
var apiAlbumEndPoint = "https://drawing-traveler-7a488b236b7c.herokuapp.com/api/v1/albums"
//render
//var apiAlbumEndPoint = "https://drawing-traveler-server.onrender.com/api/v1/albums"

//getメソッド
func apiAlbumGetRequest() async throws -> [ApiAlbum] {
    try await withCheckedContinuation { continuation in
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
func apiAlbumPostRequest(reqBody : [String: String]) async -> [String: Any] {
    var decodedMessage : [String: Any] = [:]
    await withCheckedContinuation { continuation in
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
    return decodedMessage
}
//deleteメソッド
func apiAlbumDeleteRequest(albumID : Int) async -> [String: Any] {
    var decodedMessage : [String: Any] = [:]
    await withCheckedContinuation { continuation in
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
    return decodedMessage
}
//updateメソッド
func apiAlbumUpdateReqest(reqBody : [String: String],albumID : Int) async -> [String: Any] {
    var decodedMessage : [String: Any] = [:]
    await withCheckedContinuation { continuation in
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
    return decodedMessage
}
