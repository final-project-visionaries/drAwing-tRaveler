import SwiftUI
import Alamofire



//ローカルホスト
//var apiAuthEndPoint = "http://localhost:4242/api/v1/auth"
//Heroku
var apiAuthEndPoint = "https://drawing-traveler-7a488b236b7c.herokuapp.com/api/v1/auth"
//render
//var apiAuthEndPoint = "https://drawing-traveler-server.onrender.com/api/v1/auth"

struct DecodableType: Decodable { let url: String }

//postメソッド
func apiAuthPostRequest(reqBody : [String: String]) async -> ResponseMessage {
    var message: ResponseMessage?
    do {
        await withCheckedContinuation { continuation in
            AF.request("\(apiAuthEndPoint)/login", method: .post, parameters: reqBody)
                .response{ response in
                    print("response : \(response)")
                    let decoder = JSONDecoder()
                    do {
                       message = try decoder.decode(ResponseMessage.self, from: response.data!)
                        continuation.resume(returning: message!)
                    } catch {
                        message = ResponseMessage(message: "UnAuthorize")
                        continuation.resume(returning: message!)
                    }
                }
        }
    } catch {
        print("Error connecting to the server: \(error)")
        // ここで元のページに戻るロジックを実装します。
        // 具体的な実装は、あなたのアプリのナビゲーションの設定によります。
    }
    return message!
}

//func apiImageGetRequest() async throws -> [ApiImage] {
//    try await withCheckedContinuation { continuation in
//        AF.request(apiEndPoint, method: .get)
//            .response{ response in
//                let decoder = JSONDecoder()
//                do {
//                    let images = try decoder.decode([ApiImage].self, from: response.data!)
//                    continuation.resume(returning: images)
//                    print("GET images type : \(type(of:images))")
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                    continuation.resume(throwing: error as! Never)
//                }
//            }
//    }
//}





