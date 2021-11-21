import Foundation

public enum VerbTag: CustomStringConvertible {
    
    case pastTense(Verb)
    case presentTense(Verb)
    case presentTenseThirdPersonPlural(Verb)
    case presentParticiple(Verb) // G-Form
    case pastParticiple(Verb) // N-Form
    
    public var description: String {
        
        switch self {
        case .pastTense(let verb):
            return String(describing: verb.simplePast)
        case .presentTense(let verb):
            return String(describing: verb.base)
        case .presentTenseThirdPersonPlural(let verb):
            return "present 3rd person plural"
        case .presentParticiple(let verb):
            return String(describing: verb.presentParticiple)
        case .pastParticiple(let verb):
            return String(describing: verb.pastParticiple)
        }
    }
}

// the main auxiliary verbs are to be, to have, and to do
public enum AuxiliaryVerbTag {
    
    case tense  // was, is, will be, had, will have, had been, will have been
                // the aspect of the verb can also tell us things like whether the action is habitual, ongoing, or completed and is part of tense
    case mood   // Mood is the form a verb takes to show how it is to be regarded (e.g., as a fact, a command, a wish, an uncertainty).
                // indicative, imperative, subjunctive
    case voice  // voice is the term used to describe whether a verb is active or passive.
    case modal  // can, could, may, might, must, ought to, shall, should, will, and would
                // Modal auxiliary verbs combine with other verbs to express ideas such as necessity, possibility, intention, and ability
}

public indirect enum VerbPhrase: CustomStringConvertible {
    
    case base(VerbTag)
    case auxiliary(AuxiliaryVerbTag, VerbPhrase) // can distransitive etc. be used on rhs?
    case distransitive(VerbTag, NounPhrase, NounPhrase)
    
    public var description: String {
    
        switch self {
        case .base(let tag):
            return String(describing: tag)
        case .auxiliary(let tag, let verbPhrase):
            return "auxiliary..."
        case .distransitive(let tag, let nounPhrase1, let nounPhrase2):
            return "distransitive..."
        }
    }
}


public struct Verb {
    
    static func isPresentTense(_ verbPhrase: VerbPhrase) -> Bool {

        switch verbPhrase {
        case .base(let verbTag):
            return isPresentTense(verbTag)
        case .auxiliary(_, _):
            assert(false)
        case .distransitive(_, _, _):
            assert(false)
        }
    }

    static func isPresentTense(_ verbTag: VerbTag) -> Bool {

        switch verbTag {
            
        case .pastTense(_):
            return false
        case .presentTense(_):
            return true
        case .presentTenseThirdPersonPlural(_):
            return true
        case .presentParticiple(_):
            return false
        case .pastParticiple(_):
            return false
        }
    }
    
    static func formRoot(_ verb: Verb) -> Word {
        
        let vowels: [Character] = ["a", "e", "i", "o", "u"]
        
        // we may have to look at the last 3 letters...
        
        let base = verb.base
        let string = String(describing: base)
        let stem = string.dropLast(3)
        let rest = Array(string.dropFirst(max(string.count - 3, 0)))
        if rest.count == 3 {
        
            /*
            For instance, with verbs that end in a “short” vowel followed by a consonant, we double the
            final consonant; when a verb ends in a consonant + “y,” we replace the “y” with “i”; and when
            a verb ends in “-ic,” we add the letter “k”.
            */
                        
            // panic -> panick...
            if rest[1] == "i"
               , rest[2] == "c" {
                
                return Word(stringLiteral: "\(base)k")
            }

            // come -> com...
            if rest[2] == "e" {
                
                return Word(stringLiteral: "\(stem)\(rest[0])\(rest[1])")
            }
            
            // copy -> copi...
            if !vowels.contains(rest[1])
               , rest[2] == "y" {
                
                return Word(stringLiteral: "\(stem)\(rest[0])\(rest[1])i")
            }
            
            // chop -> chopp...
            if !vowels.contains(rest[0])
               , vowels.contains(rest[1])
               , !vowels.contains(rest[2]) {
                
                return Word(stringLiteral: "\(stem)\(rest[0])\(rest[1])\(rest[2])\(rest[2])")
            }
        }
        
        /*
         
        An exception to this rule occurs for words that end in a soft vowel and the consonant “l” (as in travel, cancel, fuel, label, etc.). In this case, we merely add “-ed” to form the past simple and the past participle (as in traveled, canceled, fueled, labeled, etc.)—we do not double the consonant. Note, however, that this exception only occurs in American English; in other varieties of English, such as British or Australian English, the consonant is still doubled.
        */
        
        return Word(stringLiteral: String(describing: base))
    }

    // could return a Gerund... as part of speech
    static func formGerund(_ verb: Verb) -> Word {
        
        let base = verb.base
        let root = Verb.formRoot(verb)
        
        let string = String(describing: root)
        if let last = string.last
           , last == "i" {
        
            return Word(stringLiteral: "\(String(describing: base))ing")
        }
        
        return Word(stringLiteral: "\(String(describing: root))ing")
    }
    
    // past simple tense and past participle forms
    static func formPast(_ verb: Verb) -> Word {
        
        let root = Verb.formRoot(verb)
        return Word(stringLiteral: "\(String(describing: root))ed")
    }

    // same as formGerund...
    static func formPresent(_ verb: Verb) -> Word {
        
        let base = verb.base
        let root = Verb.formRoot(verb)
        
        let string = String(describing: root)
        if let last = string.last
           , last == "i" {
        
            return Word(stringLiteral: "\(String(describing: base))ing")
        }
        
        return Word(stringLiteral: "\(String(describing: root))ing")
    }

    private var _base: (() -> Word)!
    private let _infinitive: (() -> Infinitive)!
    private let _gerund: (() -> Word)!
    private let _presentParticiple: (() -> Word)!
    private let _pastParticiple: (() -> Word)!
    private let _simplePast: (() -> Word)!
    
    var base: Word { self._base() }
    var infinitive: Infinitive { self._infinitive() }
    var gerund: Word { self._gerund() }
    var presentParticiple: Word { self._presentParticiple() }
    var pastParticiple: Word { self._pastParticiple() }
    var simplePast: Word { self._simplePast() }
    
    let isIrregular: Bool
    
    public init(_ regular: RegularVerb) {
        
        self._base = { regular.base }
        self._infinitive = { regular.infinitive }
        self._gerund = { regular.gerund }
        self._presentParticiple = { regular.presentParticiple }
        self._pastParticiple = { regular.pastParticiple }
        self._simplePast = { regular.simplePast }
        
        self.isIrregular = false
    }
    
    public init(_ irregular: IrregularVerb) {

        self._base = { irregular.base }
        self._infinitive = { irregular.infinitive }
        self._gerund = { irregular.gerund }
        self._presentParticiple = { irregular.presentParticiple }
        self._pastParticiple = { irregular.pastParticiple }
        self._simplePast = { irregular.simplePast }

        self.isIrregular = true
    }
}


/*
 Other short words ending in ing, that can't be gerunds of a verb: ring, king, sling, sting.

 A word doesn't become a noun, adjective, gerund or any other part of speech until it is used in a sentence. So, ask not what a word "is", rather ask how it is used.

 For example "I enjoy drawing cats" (a gerund). "I have a drawing of a cat" (noun)
 
 Basically, some verbs are followed by gerunds, some verbs are followed by infinitives, and some verbs can be followed by gerunds or infinitives.
 
 Tip number one: you almost always find a gerund after a preposition. For example, “She is afraid of flying.” In this sentence “of” is the preposition and “flying” is the gerund. You cannot say “She is afraid of to fly.” An infinitive cannot be the object of a preposition, only a gerund can. You could say, “She is afraid to fly,” but in this sentence, the preposition “of” is gone.

 Tip number two: When you are talking about an activity, you usually use a gerund. For example, “I stopped smoking.” You can describe many activities by using “go” before a gerund. “Let’s go shopping,” or “We went skiing.”
 */

// Words that can be either a noun, verb adjective or adverb e.g. back, best, better...



//struct Gerund: RawRepresentable, CustomStringConvertible {
//
//    typealias RawValue = Word
//
//    var rawValue: Word
//    var description: String {
//
//        return String(describing: self.rawValue)
//    }
//
//    init?(rawValue: Word) {
//
//        // TODO: test for noun against a dictionary?
//        // use some heuristics...
//          // there are many -ing words that are not Gerund
//
//        self.rawValue = rawValue
//    }
//}

public struct Infinitive: RawRepresentable, CustomStringConvertible {

    public typealias RawValue = String

    public var rawValue: String
    public var description: String {

        return self.rawValue
    }

    public init?(rawValue: String) {

        guard rawValue.hasPrefix("to ")
              , let _ = Word(rawValue: String(rawValue.dropFirst(3))) else {
            
            return nil
        }
        
        self.rawValue = rawValue
    }
    
    init(base: Word) {
        
        self.rawValue = "to \(String(describing: base))"
    }
}


// gerund - n. an English noun formed from a verb by adding -ing


public struct RegularVerb {
                
    let base: Word                                                  // want
    var infinitive: Infinitive { Infinitive(base: self.base) }      // to want
    var gerund: Word { Verb.formGerund(Verb(self)) }                // wanting -ing
    var presentParticiple: Word { Verb.formPresent(Verb(self)) }    // wanting -ing
    var pastParticiple: Word { Verb.formPast(Verb(self)) }          // wanted   -d,-ed
    var simplePast: Word { Verb.formPast(Verb(self)) }              // wanted   -d,-ed
}

extension RegularVerb: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {

        self = RegularVerb(base: Word(stringLiteral: value))
    }
}

/*
 
 There are about 200 irregular verbs in English. We can divide these into four types:

     Verbs which have the same base form, past simple and past participle
     Verbs which have the same past simple and past participle
     Verbs which have the same base form and past participle
     Verbs which have a different base form, past simple and past participle
 */


/// have the same base form, past simple and past participle
public struct IrregularVerb1 {
    
    let base: Word                                                  // cost
    var infinitive: Infinitive { Infinitive(base: self.base) }      // to cost
    var gerund: Word { Verb.formGerund(Verb(IrregularVerb(self))) }                // cost -ing
    var presentParticiple: Word { Verb.formPresent(Verb(IrregularVerb(self))) }    // cost -ing
    var pastParticiple: Word { self.base }                          // cost
    var simplePast: Word { self.base }                              // cost
    
    public init(base: Word) {
        
        self.base = base
    }
}

extension IrregularVerb1: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {

        self = IrregularVerb1(base: Word(stringLiteral: value))
    }
}

/// have the same past simple and past participle
public struct IrregularVerb2 {
    
    let base: Word                                                  // bring
    var infinitive: Infinitive { Infinitive(base: self.base) }      // to cost
    var gerund: Word { Verb.formGerund(Verb(IrregularVerb(self))) }                // cost -ing
    var presentParticiple: Word { Verb.formPresent(Verb(IrregularVerb(self))) }    // cost -ing
    var pastParticiple: Word { self.simplePast }                    // brought
    let simplePast: Word                                            // brought
    
    public init(base: Word
                , simplePast: Word) {
        
        self.base = base
        self.simplePast = simplePast
    }
}

// extension IrregularVerb2: ExpressibleByArrayLiteral {}

//extension IrregularVerb2: ExpressibleByStringLiteral {
//
//    public init(stringLiteral value: String) {
//
//        self = IrregularVerb2(base: Word(stringLiteral: value))
//    }
//}

/// have the same base form and past participle
public struct IrregularVerb3 {
    
    let base: Word                                                              // come
    var infinitive: Infinitive { Infinitive(base: self.base) }                  // to cost
    var gerund: Word { Verb.formGerund(Verb(IrregularVerb(self))) }             // cost -ing
    var presentParticiple: Word { Verb.formPresent(Verb(IrregularVerb(self))) } // cost -ing
    var pastParticiple: Word { self.base }                                      // come
    let simplePast: Word                                                        // came
    
    public init(base: Word
                , simplePast: Word) {
        
        self.base = base
        self.simplePast = simplePast
    }
}

//extension IrregularVerb3: ExpressibleByStringLiteral {
//
//    public init(stringLiteral value: String) {
//
//        self = IrregularVerb3(base: Word(stringLiteral: value))
//    }
//}

/// have a different base form, past simple and past participle
public struct IrregularVerb4 {
    
    let base: Word                                                  // begin
    var infinitive: Infinitive { Infinitive(base: self.base) }      // to cost
    var gerund: Word { Verb.formGerund(Verb(IrregularVerb(self))) }                // cost -ing
    var presentParticiple: Word { Verb.formPresent(Verb(IrregularVerb(self))) }    // cost -ing
    let pastParticiple: Word                                        // began
    let simplePast: Word                                            // begun
    
    public init(base: Word
                , pastParticiple: Word
                , simplePast: Word) {
        
        self.base = base
        self.pastParticiple = pastParticiple
        self.simplePast = simplePast
    }
}

//extension IrregularVerb4: ExpressibleByStringLiteral {
//
//    public init(stringLiteral value: String) {
//
//        self = IrregularVerb4(base: Word(stringLiteral: value))
//    }
//}

public struct IrregularVerb {

    private var _base: (() -> Word)!
    private let _infinitive: (() -> Infinitive)!
    private let _gerund: (() -> Word)!
    private let _presentParticiple: (() -> Word)!
    private let _pastParticiple: (() -> Word)!
    private let _simplePast: (() -> Word)!
    
    var base: Word { self._base() }
    var infinitive: Infinitive { self._infinitive() }
    var gerund: Word { self._gerund() }
    var presentParticiple: Word { self._presentParticiple() }
    var pastParticiple: Word { self._pastParticiple() }
    var simplePast: Word { self._simplePast() }

    public init(_ irregular: IrregularVerb1) {

        self._base = { irregular.base }
        self._infinitive = { irregular.infinitive }
        self._gerund = { irregular.gerund }
        self._presentParticiple = { irregular.presentParticiple }
        self._pastParticiple = { irregular.pastParticiple }
        self._simplePast = { irregular.simplePast }
    }

    public init(_ irregular: IrregularVerb2) {

        self._base = { irregular.base }
        self._infinitive = { irregular.infinitive }
        self._gerund = { irregular.gerund }
        self._presentParticiple = { irregular.presentParticiple }
        self._pastParticiple = { irregular.pastParticiple }
        self._simplePast = { irregular.simplePast }
    }

    public init(_ irregular: IrregularVerb3) {

        self._base = { irregular.base }
        self._infinitive = { irregular.infinitive }
        self._gerund = { irregular.gerund }
        self._presentParticiple = { irregular.presentParticiple }
        self._pastParticiple = { irregular.pastParticiple }
        self._simplePast = { irregular.simplePast }
    }

    public init(_ irregular: IrregularVerb4) {

        self._base = { irregular.base }
        self._infinitive = { irregular.infinitive }
        self._gerund = { irregular.gerund }
        self._presentParticiple = { irregular.presentParticiple }
        self._pastParticiple = { irregular.pastParticiple }
        self._simplePast = { irregular.simplePast }
    }
}
