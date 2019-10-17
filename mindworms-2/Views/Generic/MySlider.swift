import SwiftUI

private struct SliderShape: Shape {
    let amount: Double
    func path(in rect: CGRect) -> SwiftUI.Path {
        print(rect)
        return SwiftUI.Path {
            $0.addRect(CGRect(x: rect.minX, y: rect.minY, width: rect.width * CGFloat(amount), height: rect.height))
        }
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
                .padding(10)
                }
            .gesture(DragGesture().onChanged { self.update(Double($0.location.x / self.rect.width)) })
            .overlay(GeometryFinder { self.rect = $0 })
    }
}

