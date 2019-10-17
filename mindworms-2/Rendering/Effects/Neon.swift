extension MyColor {
    func interpolated(with other: MyColor, amount: Double) -> MyColor {
        return MyColor(
            red: red + (other.red - red) * amount,
            green: green + (other.green - green) * amount,
            blue: blue + (other.blue - blue) * amount,
            alpha: alpha + (other.alpha - alpha) * amount
        )
    }
}

func neon(props: inout RenderProps, attributes: [Attribute], parameters: Any?) {
    guard
        let amount = attributes.value(for: "amount"),
        let speed = attributes.value(for: "speed")?.toRange(low: 0.003, high: 0.1),
        let params = parameters as? NeonParams,
        amount > 0.05 else { return }

    params.r += params.rUp ? (1.2 * speed) : -(1.2 * speed)
    params.rUp = params.r < 0 ? true : params.r > 1 ? false : params.rUp
    
    params.g += params.gUp ? (1.4 * speed) : -(1.4 * speed)
    params.gUp = params.g < 0 ? true : params.g > 1 ? false : params.gUp
    
    params.b += params.bUp ? (1.7 * speed) : -(1.7 * speed)
    params.bUp = params.b < 0 ? true : params.b > 1 ? false : params.bUp
   
    props.color = MyColor(red: params.r, green: params.g, blue: params.b, alpha: 1)
}
