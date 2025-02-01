//
//  Optional+Extension.swift
//  
//
//  Created by Mohamed Khater on 29/01/2025.
//

import Foundation

public extension Optional where Wrapped == String {
    var wrappedValue: Wrapped { self ?? "" }
}

public extension Optional where Wrapped == Double {
    var wrappedValue: Wrapped { self ?? .zero }
}

public extension Optional where Wrapped == Int {
    var wrappedValue: Wrapped { self ?? .zero }
}

public extension Optional where Wrapped == Float {
    var wrappedValue: Wrapped { self ?? .zero }
}

public extension Optional where Wrapped == CGFloat {
    var wrappedValue: Wrapped { self ?? .zero }
}

public extension Optional where Wrapped == Bool {
    var wrappedValue: Wrapped { self ?? false }
}

//public extension Optional where Wrapped: RangeReplaceableCollection {
//    var wrappedValue: Wrapped { self ?? Wrapped() }
//}

public extension Optional where Wrapped: Decodable {
    var wrappedValue: Wrapped { self ?? .empty }
}
