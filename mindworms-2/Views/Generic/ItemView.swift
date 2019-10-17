import SwiftUI

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
        .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(isSelected ? Color.white.opacity(0.5) : Color.clear, lineWidth: 1)
        )
            .onTapGesture {
                self.didTap()
        }
    }
}
