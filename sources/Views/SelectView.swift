import SwiftUI

struct SelectView: View {
    
    let items: [String]
    let done: (String) -> Void
    
    
    var body: some View {
        GridView(data: items, rowSize: 2) { item in
            Button(item) {
                self.done(item)
            }.buttonStyle(ButtonStyleText2())
        }
    }
}


