import Foundation

// MARK: - rendering effect -

protocol R_Effect: AnyObject {
    var id: Int { get }
    var attributes: [Attribute] { get set }
    func run(_ props: inout RenderProps)
}



// MARK: - mirror -

class Mirror: R_Effect {
    
    let id: Int
    init(id: Int) { self.id = id }
    
    var attributes: [Attribute] = []
    
    func run(_ props: inout RenderProps) {

        guard
            let x = attributes.value(for: "x"),
            let y = attributes.value(for: "y") else { return }

        if x > 0.5 {
            props.paths.append(
                contentsOf: props.paths.map { MyPath(id: $0.id, points: $0.points.map { Point(x: 1 - $0.x, y: $0.y) }) }
            )
        }

        if y > 0.5 {
            props.paths.append(
                contentsOf: props.paths.map { MyPath(id: $0.id, points: $0.points.map { Point(x: $0.x, y: 1 - $0.y) }) }
            )
        }
    }
}


// MARK: - pulse -

class Pulse: R_Effect {
    
    let id: Int
    
    init(id: Int) { self.id = id }
    
    var attributes: [Attribute] = []
    
    var width = 0.1
    var direction = false
    
    func run(_ props: inout RenderProps) {
        guard
            let amount = attributes.value(for: "amount")?.toRange(low: 1, high: 50),
            let speed = attributes.value(for: "speed")?.toRange(low: 0.01, high: 10),
            amount > 2
            else { return }
        
        
        
        let step = direction ? speed : -speed
        width += step
        
        if width > amount {
            direction = false
        }
        
        if width < 1 {
            direction = true
        }
        
        props.strokeWidth += width
    }
}



// MARK: - neon -

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

class Neon: R_Effect {
    let id: Int
    var attributes: [Attribute] = []
    init(id: Int) { self.id = id }
    
    var r = 0.0
    var g = 0.0
    var b = 0.0
    var a = 0.0
    
    var rUp = false
    var gUp = false
    var bUp = false
    var aUp = false
    
    func run(_ props: inout RenderProps) {
        guard
             let amount = attributes.value(for: "amount"),
             let speed = attributes.value(for: "speed")?.toRange(low: 0.0001, high: 0.01),
             amount > 0.05 else { return }

         r += rUp ? (1.2 * speed) : -(1.2 * speed)
         rUp = r < 0 ? true : r > 1 ? false : rUp
         
         g += gUp ? (1.4 * speed) : -(1.4 * speed)
         gUp = g < 0 ? true : g > 1 ? false : gUp
         
         b += bUp ? (1.7 * speed) : -(1.7 * speed)
         bUp = b < 0 ? true : b > 1 ? false : bUp
        
         props.color = MyColor(red: r, green: g, blue: b, alpha: 1)
    }
}

// MARK: - lofi -

private extension Array where Element == Point {
    func nearOnly(delta: Double = 0.01) -> [Element] {
        
        var current = Point(x: 0, y: 0)
        
        var result = [Element]()
        
        for el in self {
            if abs(el.x - current.x) > delta || abs(el.y - current.y) > delta {
                result.append(el)
                current = el
            }
        }

        return result
    }
}

class Lofi: R_Effect {
    let id: Int
    var attributes: [Attribute] = []
    init(id: Int) { self.id = id }
    
    func run(_ props: inout RenderProps) {
        guard let amount = attributes.value(for: "amount"), amount > 0.05 else { return }
        
        props.paths = props.paths.map { path in
            MyPath(id: path.id, points: path.points.nearOnly(delta: amount.toRange(low: 0.01, high: 0.2)))
        }
    }
}

// MARK: - grow -

class Grow: R_Effect {
    let id: Int
    var attributes: [Attribute] = []
    init(id: Int) { self.id = id }
    
    // params
    var phase = 0.0
    
    func run(_ props: inout RenderProps) {
        guard
            let speed = attributes.value(for: "speed"),
            speed > 0.05 else { return }
        
        let s = speed.toRange(low: 0.001, high: 0.1)
        phase += s
        if phase >= 1.0 { phase = 0 }
        
        props.paths = props.paths.map { path in
            MyPath(
                id: path.id,
                points: Array(
                    path.points.prefix(
                        Int(phase * Double(path.points.count - 1))
                    )
                )
            )
        }
    }
}


// MARK: - symmetry -

extension Point {
    func rotated(around center: Point, with degrees: Double) -> Point {
        let dx = self.x - center.x
        let dy = self.y - center.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) // in radians
        let newAzimuth = azimuth + degrees * Double(.pi / 180.0) // convert it to radians
        let x = center.x + radius * cos(newAzimuth)
        let y = center.y + radius * sin(newAzimuth)
        return Point(x: x, y: y)
    }
}

class Symmetry: R_Effect {
    let id: Int
    var attributes: [Attribute] = []
    init(id: Int) { self.id = id }
    
    func run(_ props: inout RenderProps) {
        guard let countVal = attributes.value(for: "count") else { return }
        
        let count = Int(countVal.toRange(low: 1, high: 15))
        
        if count <= 1 { return }
        
        let eachDegree = 360 / count
        let oldPaths = props.paths


        for path in oldPaths {
            guard let center = path.points.first else { continue }

            var symmetryPaths = [MyPath]()
            var currentDegree = 0

            while currentDegree < 360 {

                var symPath = MyPath(id: path.id, points: [])

                for point in path.points {
                    symPath.points.append(point.rotated(around: center, with: Double(currentDegree)))
                }

                symmetryPaths.append(symPath)
                currentDegree += eachDegree
            }

            props.paths.append(contentsOf: symmetryPaths)
        }
    }
}


// MARK: - cluster -
class Cluster: R_Effect {
    let id: Int
    var attributes: [Attribute] = []
    init(id: Int) { self.id = id }
    
    // params
    var tick = 0
    var subsetIndices = [Int]()
    
    func run(_ props: inout RenderProps) {
            guard
                let speed = attributes.value(for: "speed"),
                let clusters = attributes.value(for: "clusters"),
                speed > 0.05 else { return }

            let speed2 = speed.toInt(1, 10)

            if tick % speed2 == 0 {
                subsetIndices = props.paths.indiciesSubset(fraction: clusters)
            }
            
            tick = tick > 100 ? 1 : tick + 1
            props.paths.subset(idxs: subsetIndices)
    }
}

extension Double {
    func toInt(_ low: Int, _ high: Int) -> Int {
        return low + Int(self * Double(high))
    }
}

extension Array {

    func indiciesSubset(fraction: Double) -> [Index] {
        
        var result = [Int]()
        
        if indices.count == 0 { return [] }
        
        let num = fraction.toInt(indices.min()!, indices.max()!) + 1
        
        var ins = Array<Int>(indices)
        
        guard num <= ins.count else { fatalError() }
        
        for _ in 0..<num {
            if let i = ins.indices.randomElement() {
                result.append(ins[i])
                ins.remove(at: i)
            }
        }
        
        return result
    }
    
    mutating func subset(idxs: [Index]) {
        for i in indices.reversed() {
            if !idxs.contains(i) {
                remove(at: i)
            }
        }
    }
}

// MARK: - flicker -

class Flicker: R_Effect {
    let id: Int
    var attributes: [Attribute] = []
    init(id: Int) { self.id = id }
    
    // params
    var tick = 0
    
    func run(_ props: inout RenderProps) {
        guard
            let amount = attributes.value(for: "amount"),
            let speed = attributes.value(for: "speed"),
            speed > 0.05 else { return }
        
        let s = Int(speed.toRange(low: 20, high: 1))
        tick = tick > 100 ? 1 : tick + 1
        props.color = props.color.with(alpha: tick % Int(s) < Int(s / 2) ? 1 : 1 - amount)
    }
}


// MARK: - color -

class ColorChanger: R_Effect {
    let id: Int
    var attributes: [Attribute] = []
    init(id: Int) { self.id = id }
    
    func run(_ props: inout RenderProps) {
        guard
            let red = attributes.value(for: "red"),
            let green = attributes.value(for: "green"),
            let blue = attributes.value(for: "blue"),
            let alpha = attributes.value(for: "alpha") else { return }

        props.color = props.color.interpolated(with: MyColor(red: red, green: green, blue: blue, alpha: alpha), amount: 0.9)
    }
}

// MARK: - shake -

private extension MyPath {
    func withUpdated(points: [Point]) -> MyPath { .init(id: id, points: points) }
}

class Shake: R_Effect {
    let id: Int
    var attributes: [Attribute] = []
    init(id: Int) { self.id = id }
    
    // params
    var index = 0
    var target = 100
    var directionUp = false
    
    var r1 = Int(Utilities.random() * 10) + 1 // + 0.001 no zero error
    var r2 = Int(Utilities.random() * 10) + 1
    var r3 = Int(Utilities.random() * 10) + 1
    var r4 = Int(Utilities.random() * 10) + 1
    
    func run(_ props: inout RenderProps) {
        guard
               let amount = attributes.value(for: "amount"),
               let speed = attributes.value(for: "speed")?.toRange(low: 1, high: 5),
               amount > 0.05 else { return }
           
           let a = amount.toRange(low: 0, high: 0.04)
           
           func shaken(path: MyPath) -> MyPath {
               
               path.withUpdated(points: path.points.enumerated().map { p in
                   if p.offset % r1 == 0 {
                       return Point(
                           x: p.element.x - (Double(index) / 100) * a,
                           y: p.element.y - (Double(index) / 100) * a
                       )
                   }
                   
                   if p.offset % r2 == 0 {
                       return Point(
                           x: p.element.x + (Double(index) / 100) * a,
                           y: p.element.y + (Double(index) / 100) * a
                       )
                   }
                   
                   if p.offset % r3 == 0 {
                       return Point(
                           x: p.element.x - (Double(index) / 100) * a,
                           y: p.element.y + (Double(index) / 100) * a
                       )
                   }
                   
                   if p.offset % r4 == 0 {
                       return Point(
                           x: p.element.x + (Double(index) / 100) * a,
                           y: p.element.y - (Double(index) / 100) * a
                       )
                   }
                   
                   return p.element
               })
           }
           

           if directionUp && index >= target || !directionUp && index <= target {
               
               target = Int(Utilities.random() * 100)
               directionUp = target > index
           }
           
           let s = Int(speed)
           index += target >= index ? s : -s
           
           props.paths = props.paths.map(shaken)
    }
}


// MARK: - spin -
extension MyPath {
    func newPoints(f: (Point) -> Point) -> MyPath {
        MyPath(id: id, points: points.map(f), isSelected: isSelected)
    }
}

class Spin: R_Effect {
    let id: Int
    var attributes: [Attribute] = []
    init(id: Int) { self.id = id }
    
    // params
    var theta = 0.0
    
    func run(_ props: inout RenderProps) {
        guard
            let speed = attributes.value(for: "speed"),
            speed > 0.05 else { return }
        
        theta += 1
        if theta > 360 { theta = 0 }
        
        props.paths = props.paths.map { path in
            path.newPoints { $0.rotated(around: .init(x: 0.5, y: 0.5), with: theta) }
        }
    }
}

