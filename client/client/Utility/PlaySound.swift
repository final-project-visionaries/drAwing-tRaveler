import Foundation // -> SoundPlay（バックミュージックの再生）
import AVFoundation // -> SoundPlay（バックミュージックの再生）
import SwiftUI // -> SoundManager（効果音の再生）
import AVKit // -> SoundManager（効果音の再生）

// バックミュージックの再生用
class BgmPlay{
    var audioPlayerInstance : AVAudioPlayer! = nil
    func play(fileName:String, extentionName:String){
        //パスを生成
        guard let soundFilePath = Bundle.main.path(forResource:fileName, ofType: extentionName) else {
            print("サウンドファイルが見つかりません。")
            return
        }
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        // AVAudioPlayerのインスタンスを作成,ファイルの読み込み
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        //バックミュージック流しながらでも効果音を流すコード
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSession.Category.ambient)
            try audioSession.setActive(true)
        } catch let error {
            print(error)
        }
        audioPlayerInstance.prepareToPlay()  // 再生準備
        audioPlayerInstance.currentTime = 0  // 再生箇所を頭に移す
        audioPlayerInstance.play()
    }
}

// 効果音の再生用
class SoundManager {
    static let instance = SoundManager() // Singleton(インスタンスを１つ以上作らせない)
    var player: AVAudioPlayer?
    func playSound(sound: String, withExtension: String){
        guard let url = Bundle.main.url(forResource: sound, withExtension: withExtension) else {return}
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }catch let error{
            print("Error playing music : \(error.localizedDescription)")
        }
    }
}
