import SwiftUI

struct Spacing {
    let small: CGFloat = 5
    let medium: CGFloat = 10
    let large: CGFloat = 15
}

struct Colors {
    let tint = Color.init(.sRGB, red: 0.1, green: 0.1, blue: 0.2, opacity: 0.8)
    let mainBG = Color(.sRGB, red: 0.1, green: 0.3, blue: 0.3)
    let secondaryBG = Color.black.opacity(0.2)
    let textForeground1 = Color(.sRGB, red: 0.8, green: 0.9, blue: 1, opacity: 0.9)
    let highlight = Color.white.opacity(0.6)
    let border1 = Color.init(.sRGB, red: 0.8, green: 0.85, blue: 0.7, opacity: 0.5)
    let lightest = Color.init(.sRGB, red: 0.95, green: 0.85, blue: 1, opacity: 0.85)
    let lighter = Color.init(.sRGB, red: 0.95, green: 0.85, blue: 1, opacity: 0.7)
    let light = Color.init(.sRGB, red: 0.95, green: 0.85, blue: 1, opacity: 0.6)
    let dark = Color.init(.sRGB, red: 0.80, green: 0.85, blue: 1, opacity: 0.15)
    let canvasBG = Color(.sRGB, red: 0.6, green: 0.6, blue: 0.7, opacity: 0.7)
}

struct Fonts {
     let title = Font.system(size: 22)
     let heading = UIFont.systemFont(ofSize: 24)
     let subheading = UIFont.systemFont(ofSize: 20)
     let body = Font.system(size: 16)
     let small = UIFont.systemFont(ofSize: 11)
 }

struct Sizes {
    struct Size {
        let width: CGFloat
        let height: CGFloat
    }
    let item1 = Size(width: 40, height: 40)
}

class Style: ObservableObject {
    var spacing = Spacing()
    var fonts = Fonts()
    var cornerRadius1: CGFloat = 5
    var colors = Colors()
    var sizes = Sizes()
}



struct ButtonStyleSecondary: ButtonStyle {
//    let isSelected: Bool
//    init(isSelected: Bool = false) {
//        self.isSelected = isSelected
//    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
//            .frame(minWidth: style.sizes.item1.width, minHeight: style.sizes.item1.height)
//            .padding(style.spacing.small)
            .foregroundColor(style.colors.textForeground1)
//            .background(
//                RoundedRectangle(cornerRadius: style.cornerRadius1)
//                    .stroke(isSelected ? style.colors.highlight : style.colors.tint)
//        )
    }
}

struct CommandButtonStyle: ButtonStyle {
    let isSelected: Bool
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, style.spacing.small)
            .foregroundColor(style.colors.tint)
            .background(
                ZStack {
                    Rectangle()
                    .stroke(isSelected ? style.colors.highlight : style.colors.secondaryBG)
                    Rectangle()
                    .fill(isSelected ? style.colors.highlight : style.colors.secondaryBG)
                }
                    
        )
    }
}

struct ButtonStyle1: ButtonStyle {
    let isSelected: Bool
    init(isSelected: Bool = false) { self.isSelected = isSelected }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, style.spacing.small)
            .background(
                ZStack {
                    Rectangle()
                        .fill(isSelected ? style.colors.tint : style.colors.secondaryBG)
                    configuration.label.modifier(PrimaryLabel())
                }           
        )
    }
}

struct ButtonStyleText: ButtonStyle {
    let isSelected: Bool
    init(isSelected: Bool = false) { self.isSelected = isSelected }
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .modifier(PrimaryLabel())
            .border(isSelected ? style.colors.highlight : Color.clear)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
    }
}

struct ButtonStyleText2: ButtonStyle {
    let isSelected: Bool
    init(isSelected: Bool = false) { self.isSelected = isSelected }
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
//            .frame(width: 40, height: 40)
            .padding(style.spacing.medium)
            .foregroundColor(style.colors.lightest)
            .font(style.fonts.title)
            .overlay(Color.white.opacity(0.01))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(RoundedRectangle(cornerRadius: 2).fill(isSelected ? style.colors.dark : Color.clear))
//            .border(isSelected ? style.colors.highlight : Color.clear)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
    }
}




struct PrimaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(style.spacing.small)
            .foregroundColor(style.colors.lightest)
            .font(style.fonts.title)
    }
}


struct SecondaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(style.spacing.small)
            .foregroundColor(style.colors.lightest)
            .font(style.fonts.body)
    }
}
