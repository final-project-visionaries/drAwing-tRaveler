import SwiftUI

struct LoadingView: View { // データがまだGETされていない場合に表示
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.white).opacity(0.6)
            ProgressView("Now Loading...").tint(.black).foregroundStyle(.blue)
        }
    }
}
