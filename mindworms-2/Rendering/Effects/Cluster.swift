
import Foundation

func cluster(props: inout RenderProps, attributes: [Attribute], parameters: Any?) {
    guard
//        let amount = attributes.value(for: "amount"),
        let speed = attributes.value(for: "speed"),
        let clusters = attributes.value(for: "clusters"),
        let params = parameters as? ClusterParams,
        speed > 0.05 else { return }

    let speed2 = speed.toInt(1, 10)

    if params.tick % speed2 == 0 {
        params.subsetIndices = props.paths.indiciesSubset(fraction: clusters)
    }
    
    params.tick = params.tick > 100 ? 1 : params.tick + 1
    
    props.paths.subset(idxs: params.subsetIndices)
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
