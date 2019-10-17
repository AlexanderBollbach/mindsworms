import Foundation

func color(props: inout RenderProps, attributes: [Attribute], parameters: Any?) {
    guard
        let red = attributes.value(for: "red"),
        let green = attributes.value(for: "green"),
        let blue = attributes.value(for: "blue"),
        let alpha = attributes.value(for: "alpha") else { return }

    props.color = props.color.interpolated(with: MyColor(red: red, green: green, blue: blue, alpha: alpha), amount: 0.9)
}
