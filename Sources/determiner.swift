import Foundation

// https://dictionary.cambridge.org/grammar/british-grammar/all



public enum DeterminerUsableInIsolation {
    
    case many
    case each
    case few
    case some
    case all

    var description: String {
        
        switch self {
            
        case .many:
            return "many"
        case .each:
            return "each"
        case .few:
            return "few"
        case .some:
            return "some"
        case .all:
            return "all"
        }
    }
}

// NounPhrase (enum) contains a NounTag (enum) which contains a Noun (struct)
// rather than have a specific NounPhrase e.g. isolation, which elevates a specific 'tag' that is a subset i.e. DeterminerTagFormingNounPhrasesInIsolation
// have an algebraic type that
// NounPhrase (enum) => .determiner =>

// https://en.wikipedia.org/wiki/Determiner
// The indefinite articles a and an are used to modify singular nouns which is handled higher up
public enum Determiner { // when specifiying what is below...
  
    case definite // the
    case proximal // this, these
    case distal // that, those
    case possessive // my, their
    case quantifier // all, some, many, few, and no...
    case distributive // each, any, either, and neither...
}

public enum ModifierTag {
    
    // modifiers come before the Noun in a Noun-Phrase
    // they are adjectives or other Nouns, first the adjectives, then the nouns...
}
