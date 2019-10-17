import SwiftUI

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
