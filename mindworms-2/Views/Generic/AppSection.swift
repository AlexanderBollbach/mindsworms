import SwiftUI

struct AppSection<Content: View>: View {
    @EnvironmentObject var style: Style
    var title: String?
    let content: () -> Content
    
    let cornerRadius: CGFloat = 4.0
    
    init(_ title: String? = nil, content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
//        content()
//        VStack {
//            //            title.map {
//            //                Text($0).font(.system(size: 10))
//            //            }
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: 0.55)
                    .foregroundColor(style.sectionBorderColor)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(style.sectionBackgroundColor)
                content()
////                    .layoutPriority(1)
                    .padding(CGFloat(style.sectionPadding))
            }
//            .layoutPriority(1)
//        }
    }
}
