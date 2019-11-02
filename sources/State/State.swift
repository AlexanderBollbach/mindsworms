import Foundation

// MARK: - app -

var _idCounter = 0

func genID() -> Int {
    _idCounter += 1
    return _idCounter
}

