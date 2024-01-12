import SwiftUI

struct CustomBackButton: ViewModifier {
    @Environment(\.dismiss) var dismiss
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            PlaySound.instance.playSound(filename: "top")
                            dismiss()
                        }, label: {Image(systemName: "arrow.backward")}
                    )
                    .tint(.blue).font(.title).fontWeight(.bold)
                }
            }
    }
}

struct CustomBackButton2: ViewModifier {
    @Environment(\.dismiss) var dismiss
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            PlaySound.instance.playSound(filename: "top")
                            dismiss()
                        }, label: {Image(systemName:"rectangle.portrait.and.arrow.forward")}
                    )
                    .tint(.blue).font(.title).fontWeight(.bold)
                }
            }
    }
}

extension View {
    func customBackButton() -> some View {
        self.modifier(CustomBackButton())
    }
    func customBackButton2() -> some View {
        self.modifier(CustomBackButton2())
    }
}
