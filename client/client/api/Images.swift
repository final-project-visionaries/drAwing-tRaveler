import SwiftUI
import Alamofire

//getリクエストの返り値の型定義
struct ApiImage: Codable {
    var id:Int
    var image_name: String
    var image_data : String
    var updated_at : String
}
//post・patch・deleteリクエストの返り値の型定義
struct ResponseMessage: Codable {
    var message:String
}
//ローカルホスト
//var apiEndPoint = "http://localhost:4242/api/v1/images"
//Heroku
var apiEndPoint = "https://drawing-traveler-7a488b236b7c.herokuapp.com/api/v1/images"
//render
//var apiEndPoint = "https://drawing-traveler-server.onrender.com/api/v1/images"

//getメソッド
func apiImageGetRequest() async throws -> [ApiImage] {
    try await withCheckedContinuation { continuation in
        AF.request(apiEndPoint, method: .get)
            .response{ response in
                let decoder = JSONDecoder()
                do {
                    let images = try decoder.decode([ApiImage].self, from: response.data!)
                    continuation.resume(returning: images)
                    print("GET images type : \(type(of:images))")
                } catch {
                    print("Error decoding JSON: \(error)")
                    continuation.resume(throwing: error as! Never)
                }
            }
    }
}
//postメソッド
func apiImagePostRequest(reqBody : [String: String]) async -> [String: Any] {
    var decodedMessage : [String: Any] = [:]
    await withCheckedContinuation { continuation in
        AF.request(apiEndPoint, method: .post, parameters: reqBody)
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
func apiImageDeleteRequest(imageID : Int) async -> [String: Any] {
    var decodedMessage : [String: Any] = [:]
    await withCheckedContinuation { continuation in
        AF.request("\(apiEndPoint)/\(imageID)", method: .delete)
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
func apiImageUpdateReqest(reqBody : [String: String],imageID : Int) async -> [String: Any] {
    var decodedMessage : [String: Any] = [:]
    await withCheckedContinuation { continuation in
        AF.request("\(apiEndPoint)/\(imageID)", method: .patch, parameters: reqBody)
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
