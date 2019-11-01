import SwiftUI

struct CommandsView: View {
   
    struct Item: Identifiable {
        
        let id: Int
        var title: String?
        var imageName: String?
        let isSelected: Bool
        let action: () -> Void
        
        
        init(id: Int = genID(), title: String? = nil, imageName: String? = nil, isSelected: Bool = false, action: @escaping () -> Void) {
            self.id = id
            self.title = title
            self.imageName = imageName
            self.isSelected = isSelected
            self.action = action
        }
    }
    
    var items: [Item]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(items) {
                    self.view(for: $0)
                }
            }
        }
    }
    
    func view(for item: Item) -> some View {
        Group {
            if item.title != nil {
                textButton(item: item)
            }

            if item.imageName != nil {
                imageButton(item: item)
            }
        }
    }
    
    private func imageButton(item: Item) -> some View {
        Button(action: item.action) {
            Image(systemName: item.imageName!).background(Color.white.opacity(0.01))
        }
        .buttonStyle(ButtonStyleText(isSelected: item.isSelected))
    }
    
    private func textButton(item: Item) -> some View {
        Button(item.title!, action: item.action)
            .buttonStyle(ButtonStyleText(isSelected: item.isSelected))
    }
}
