import SwiftUI

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

