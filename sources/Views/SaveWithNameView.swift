import SwiftUI

struct SaveWithNameView: View {
    let message: String
    @State private var text: String = ""
    
    let onFinish: (String) -> Void
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Section {
                VStack {
                    TextField("\(self.message): ", text: self.$text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("done") {
                        self.onFinish(self.text)
                    }
                    .buttonStyle(ButtonStyleText())
                }
            }
            Spacer()
        }.padding(style.spacing.large)
    }
}
