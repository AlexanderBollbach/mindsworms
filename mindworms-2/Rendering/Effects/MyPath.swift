import Foundation

struct MyPath: Identifiable {
    let id: UUID
    var points: [Point] = []
}

//extension MyPath: Creatable {
//    static func create(id: UUID) -> MyPath {
//        return MyPath(id: id)
//    }
//}
