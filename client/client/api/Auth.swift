import SwiftUI
import Alamofire

//ローカルホスト
//var apiAuthEndPoint = "http://localhost:4242/api/v1/auth"
//Heroku
var apiAuthEndPoint = "https://drawing-traveler-7a488b236b7c.herokuapp.com/api/v1/auth"
//render
//var apiAuthEndPoint = "https://drawing-traveler-server.onrender.com/api/v1/auth"

//postメソッド
func apiAuthPostRequest(reqBody : [String: String]) async -> ResponseMessage {
    var message: ResponseMessage?
    return await withCheckedContinuation { continuation in
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
}

//新規登録用postメソッド
func apiSignUpPostRequest(reqBody : [String: String]) async -> ResponseMessage {
    var message: ResponseMessage?
    return await withCheckedContinuation { continuation in
        AF.request("\(apiAuthEndPoint)/signup", method: .post, parameters: reqBody)
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
}
