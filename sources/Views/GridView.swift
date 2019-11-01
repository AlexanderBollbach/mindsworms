import SwiftUI

struct GridView<Item: Identifiable, Content: View>: View {
    let data: [Item]
    let rowSize: Int
    let getContent: (Item) -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(asNSized, id: \.0) { vals in
                HStack {
                    ForEach(vals.1) {
                        self.getContent($0)
                    }
                }
            }
        }
    }
    
    private var asNSized: [(String, [Item])] {
        var d = data
        var r = [(String, [Item])]()
        var count = 1
        while !d.isEmpty {
            let nextN = d.prefix(rowSize)
            d = Array(d.dropFirst(rowSize))
            r.append(("\(count)", Array(nextN)))
            count += 1
        }
        return r
    }
}
