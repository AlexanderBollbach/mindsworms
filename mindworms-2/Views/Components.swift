import SwiftUI

private struct SliderShape: Shape {
    let amount: Double
    func path(in rect: CGRect) -> SwiftUI.Path {
        return SwiftUI.Path { $0.addRect(CGRect(x: rect.minX, y: rect.minY, width: rect.width * CGFloat(amount), height: rect.height)) }
    }
}

struct MySlider: View {
    @EnvironmentObject var style: Style
    @State var rect: CGRect = .zero
    
    let title: String
    let amount: Double
    let update: (Double) -> Void
    var body: some View {
        ZStack {
            SliderShape(amount: 1.0)
                .fill(Color.white.opacity(0.05))
                .frame(width: self.rect.size.width, height: self.rect.size.height)
            SliderShape(amount: self.amount)
                .fill(self.style.sliderBGColor)
            Text(self.title)
                .padding(5)
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
        Group {
            if store.optionalView({ $0 }, { $0 }) != nil {
                self.content(store.optionalView({ $0 }, { $0 })!)
            } else {
                self.empty
            }
        }
    }
}

// MARK: - section -

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

struct ItemView: View {
    
    @EnvironmentObject var style: Style
    
    let title: String
    let isSelected: Bool
    let didTap: () -> Void
    
    init(title: String, isSelected: Bool = false, didTap: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.didTap = didTap
    }
    
    var body: some View {
        Text(title)
            .padding(7)
            .foregroundColor(.white)
            .background(Color.white.opacity(0.1))
            //        .cornerRadius(6)
            .overlay(
                Rectangle()
                    .stroke(isSelected ? Color.white.opacity(0.5) : Color.clear, lineWidth: 1)
        )
            .onTapGesture {
                self.didTap()
        }
    }
}

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

