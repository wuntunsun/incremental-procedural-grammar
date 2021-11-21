import Foundation

public struct Word: RawRepresentable, CustomStringConvertible, Hashable {
    
    public static func == (lhs: Word, rhs: Word) -> Bool {
        
        return String(describing: lhs) == String(describing: rhs)
    }
    
    public typealias RawValue = String
    
    public var rawValue: String
    public var description: String {
        
        return self.rawValue
    }
    
    public init?(rawValue: String) {
        
        guard rawValue.filter({ $0.isLetter }) == rawValue
            , !rawValue.isEmpty else {
            
            return nil
        }
        
        self.rawValue = rawValue
    }
}

extension Word: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {

        self.rawValue = value.filter { $0.isLetter }
    }
}

public struct Adjective {
    
    // TODO: will take a Word
}
