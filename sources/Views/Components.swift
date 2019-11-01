import SwiftUI

private struct SliderShape: Shape {
    let amount: Double
    func path(in rect: CGRect) -> SwiftUI.Path {
        return SwiftUI.Path { $0.addRect(CGRect(x: rect.minX, y: rect.minY, width: rect.width * CGFloat(amount), height: rect.height)) }
    }
}

struct MySlider: View {
    @State var rect: CGRect = .zero
    
    let title: String
    let amount: Double
    let update: (Double) -> Void
    var body: some View {
        ZStack {
            // this view is to allow gesture to work with infinitesimal opacity
            SliderShape(amount: 1.0)
                .fill(Color.white.opacity(0.0005))
//                .frame(width: self.rect.size.width, height: self.rect.size.height)
            SliderShape(amount: self.amount)
                .fill(style.colors.dark)
            RoundedRectangle(cornerRadius: style.cornerRadius1)
                .stroke(style.colors.lightest.opacity(0.6))
            Text(self.title)
                .modifier(PrimaryLabel())
        }
        .gesture(DragGesture().onChanged { self.update(Double($0.location.x / self.rect.width)) })
        .overlay(GeometryFinder { self.rect = $0 })
    }
}

// MARK: - optional store view -

struct OptionalStoreView<Empty: View, State, Action, Content: View>: View {
    let empty: Empty
    let content: (Store<State, Action>) -> Content
    @ObservedObject var store: Store<State?, Action>
    var body: some View {
        VStack {
            if store.optionalView({ $0 }, { $0 }) != nil {
                self.content(store.optionalView({ $0 }, { $0 })!)
            } else {
                self.empty
            }
        }
    }
}

// MARK: - section -
//
//struct AppSection<Content: View>: View {
//    var title: String?
//    let content: () -> Content
//    
//    
//    init(_ title: String? = nil, content: @escaping () -> Content) {
//        self.title = title
//        self.content = content
//    }
//    
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: style.cornerRadius1)
//                .stroke(lineWidth: 0.55)
//                .foregroundColor(style.colors.mainBG)
//            RoundedRectangle(cornerRadius: style.cornerRadius1)
//                .fill(style.sectionBackgroundColor)
//            content()
//                .padding(CGFloat(style.spacing.medium))
//        }
//    }
//}

// MARK: - geometry finder -


struct RectPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = CGRect.zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct GeometryFinder: View {
    
    var coordinateSpace: CoordinateSpace = .global
    var onUpdate: (CGRect) -> Void
    
    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: RectPreferenceKey.self, value: proxy.frame(in: self.coordinateSpace))
        }
        .onPreferenceChange(RectPreferenceKey.self) { value in
            self.onUpdate(value)
        }
    }
}

// MARK: - paged -

//struct ItemView: View {
//
//    @EnvironmentObject var style: Style
//
//    let title: String
//    let isSelected: Bool
//    let didTap: () -> Void
//
//    init(title: String, isSelected: Bool = false, didTap: @escaping () -> Void) {
//        self.title = title
//        self.isSelected = isSelected
//        self.didTap = didTap
//    }
//
//    var body: some View {
//        Text(title)
//            .padding(7)
//            .foregroundColor(.white)
//            .background(Color.white.opacity(0.1))
//            //        .cornerRadius(6)
//            .overlay(
//                Rectangle()
//                    .stroke(isSelected ? Color.white.opacity(0.5) : Color.clear, lineWidth: 1)
//        )
//            .onTapGesture {
//                self.didTap()
//        }
//    }
//}

// MARK: - paged -


extension Array {
    func page(index: Int, size: Int) -> [Element] {
        let start = index * size
        var end = start + size
        
        if let max = indices.max() {
            if end > max {
                end = max
            }
        } else {
            fatalError("could crash")
        }
        
        return Array(self[start..<end])
    }
}

struct PagedView<E: Identifiable, Content: View>: View {
    @State var index = 0
    
    var pageSize = 5
    var elements: [E]
    let getContentView: (E) -> Content?
    //    let tapped: (E.ID) -> Void
    
    func contentView(_ i: Int) -> some View {
        let element = self.elements[i]
        return self.getContentView(element)
        //            ?
        //            .onTapGesture {
        //            self.tapped(element.id)
        //        }
    }
    
    func nextPage() { index = index == lastPage ? 0 : index + 1 }
    func previousPage() { index = index == 0 ? lastPage : index - 1 }
    var lastPage: Int { elements.count / pageSize }
    
    var pageRange: Range<Int> {
        index * pageSize..<index * pageSize + pageSize
    }
    
    var body: some View {
        return HStack() {
            Button(action: { self.previousPage() }) { Text("prev") }
            Button(action: { self.nextPage() }) { Text("next") }
            ForEach(pageRange, id: \.self) { i in
                self.elements.indices.contains(i) ? self.contentView(i) : nil
            }
            Spacer()
        }
    }
}


public struct UnwrapView<Some: View, None: View>: View {

    private let some: () -> Some?
    private let none: () -> None?

    public init<Value>(value: Value?,
                       some: @escaping (Value) -> Some,
                       none: @escaping () -> None) {

        self.some = { value.map(some) }
        self.none = { value == nil ? none() : nil }
    }

    public var body: some View {
        Group {
            some()
            none()
        }
    }
}
