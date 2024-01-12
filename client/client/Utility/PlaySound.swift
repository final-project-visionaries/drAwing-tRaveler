import AVFoundation
import SwiftUI

// バックミュージックの再生用
class PlayBGM{
    static let instance = PlayBGM()
    var player : AVAudioPlayer! = nil
    func playBGM(filename:String){
        do {
            //バックミュージック流しながらでも効果音を流せるようにする設定
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSession.Category.ambient)
            try audioSession.setActive(true)
            player = try AVAudioPlayer(data: NSDataAsset(name: filename)!.data)
            player.volume = 0.2
            player.numberOfLoops = -1
            player.play()
        } catch let error {
            print(error)
        }
    }
}

// 効果音の再生用
class PlaySound {
    static let instance = PlaySound() // Singleton(インスタンスを１つ以上作らせない)
    var player : AVAudioPlayer! = nil
    func playSound(filename: String){
        do{
            player = try AVAudioPlayer(data: NSDataAsset(name: filename)!.data)
            player.play()
        }catch let error{
            print("Error playing music : \(error.localizedDescription)")
        }
    }
}
