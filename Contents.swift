import Foundation

/*
 
 G=(N,T,S,P,D,W,O)
 
 N is a set of non-terminal symbols
 T is a set of terminal symbols
 S is a set of segments
 P is a set of phonetic symbols
 F is a set of feature symbols
 W is a set of value symbols
 O is a set of grammatical function symbols
 
 f-structures are connected directed acyclic graphs defined by (V,E,Fw,Fl,Fo)
 
 V is a set of nodes
 E
 Fw is a patial function
 Fl is a labelling function
 Fo
 
 c-structures (PS trees) (V,Fm,<,Fl)
 
 Derived from f-structures by means of the destination and linerization processes.
 
 Derived from a context free grammar in LFG and other formalisms.
 
 Segments are graphs with two nodes; a root node and a foot node.
 
 Phonetic strings are the sequences of terminal nodes in c-structures.
 
 concatenation - vertical composition unifying a root and a foot
 furcation - horizontal composition unifying two roots
 
 features such as finite, nominative, plural aure unified
 Also direct-object, definite, determiner, head
 
 S - sentence
 P - phrase
 W - word
 VP - verb phrase
 NP - nound phrase
 NNS -
 V - verb
 Adj - adjective
 AdjP - Adjective Phrase
 AdvP - Adverb Phrase
 Nom - Nominitave
 Det - Determiner
 Neg - Negation
 PP - Prepositional Phrase
 P - Preposition
 ToP - ??
 IN = 
 
 subject is NP
 predicate is VP
 
 Branches join at a node, each node corresponds to a set of words that act together as a unit
 called a constituent.
 
 In traditional grammar, a part of speech or part-of-speech (abbreviated as POS or PoS) is a category of words (or, more generally, of lexical items) that have similar grammatical properties. Words that are assigned to the same part of speech generally display similar syntactic behavior—they play similar roles within the grammatical structure of sentences—and sometimes similar morphology in that they undergo inflection for similar properties.
 
  a simple sentence is made up of a subject + a verb + possibly an object. This sentence structure is sometimes represented as SVO
  
 A simple sentence consists of one main (or independent) clause. To be complete, a simple sentence must have at least one subject and one verb.

 Example: The man (subject) went (verb) to the store (object).
 */

enum Sentence {
    
    case simple(subject: NounPhrase, VerbPhrase, object: NounPhrase?)
}

/*
 
 A proper noun is a noun that identifies a single entity and is used to refer to that entity, such as London, Jupiter, Sarah, or Microsoft, as distinguished from a common noun, which is a noun that refers to a class of entities (city, planet, person, corporation) and may be used when referring to instances of a specific class (a city, another planet, these persons, our corporation).[1][2][3][4] Some proper nouns occur in plural form (optionally or exclusively), and then they refer to groups of entities considered as unique (the Hendersons, the Everglades, the Azores, the Pleiades). Proper nouns can also occur in secondary applications, for example modifying nouns (the Mozart experience; his Azores adventure), or in the role of common nouns (he's no Pavarotti; a few would-be Napoleons). The detailed definition of the term is problematic and, to an extent, governed by convention
*/

enum NounTag {
    
    // handle countable/uncountable...
    // properNoun, properName (phrase)
    
    case singularNoun(Noun)             // NN
    case pluralNoun(PluralisableNoun)   // NNS
    case properNoun         // NNP
    case pluralProperNoun   // NNPS
}


enum DeterminerTag {
    
    case any  // ALL, SOME, MOST, MORE, ENOUGH, NO and ANY
    case countable  // THE, A, ALL, AN, ANOTHER, EVERY, BOTH, EACH, EITHER, FEW, MANY, SEVERAL, MOST, NEITHER, NO and ANY
    case uncountable    // ENOUGH, LITTLE, MORE, SOME and MUCH
         // ALL, SOME, MOST, MORE, ENOUGH, NO and ANY
    case formingNounPhasesInIsolation // many, few, each, some, all
}

enum DeterminerTagFormingNounPhrasesInIsolation {
    
    case many
    case each
    case few
    case some
    case all
}

enum ModifierTag {
    
    // are there categories of derterminer?
}

/*
 Case and number distinctions do not apply to all pronoun types. In fact, they apply only to personal pronouns, possessive pronouns, and reflexive pronouns. It is only in these types, too, that gender differences are shown (personal he/she, possessive his/hers, reflexive himself/herself). All other types are unvarying in their form.

 Many of the pronouns listed above also belong to another word class - the class of determiners. They are pronouns when they occur independently, that is, without a noun following them, as in This is a new car. But when a noun follows them - This car is new - they are determiners. We will look at determiners in the next section.

 A major difference between pronouns and nouns generally is that pronouns do not take the or a/an before them. Further, pronouns do not take adjectives before them, except in very restricted constructions involving some indefinite pronouns (a little something, a certain someone).
 */

enum PronounTag {
    
    case personal // [SUBJECTIVE CASE] I, you, he/she/it... we, you, they... [OBJECTIVE CASE] me, you, him/her/it... us, you, them
    case possessive // mine, yours, his, hers, ours, theirs
    case reflexive  // myself, yourself, himself, herself, itself, oneself, ourselves, yourselves, themselves
    case reciprocal // each other, one another
    case demonstrative  // this, that, these, those
    case relative   // that, which, who, whose, whom, where, when
    case interrogative  // who, what, why, where, when, whatever
    case indefinite // anything, anybody, anyone, something, somebody, someone, nothing, nobody, none, no one
}

// there are singular and uncountable nouns which have no plural e.g. physics, economics, news, athletics
// there are singular and countable nouns which have a plural e.g. bean, pea, bike, water
// there are collective nouns which are treated as singular e.g. team, family, class, union, army, committee

// all of NounTag, DeterminerTag, and PronounTag can be uncountable, countable or collective

enum NounPhrase { // NP
    
    case base(NounTag)
    case isolation(DeterminerTagFormingNounPhrasesInIsolation) // forming noun phrase in isolation e.g. 'Each' impressed me. Context!
                            // The, A, Every are ungrammatical despite being possible
                            // So this is a subset of DeterminerTag...
    //case determiner(DeterminerTag, NounTag)
    //case bar(DeterminerTag, [NounTag]) // flattened structure... could be compound
    case determiner(DeterminerTag, [ModifierTag], [NounTag]) // empty array could handle cases...
    // when DeterminerTag.countable then need a countable NounTag...
    // usually decide on noun and mach determiner to it based on context right?
    
    // A pro-form is a type of function word or expression that stands in for (expresses the same content as) another word, phrase, clause or sentence where the meaning is recoverable from the context.[4] In English, pronouns mostly function as pro-forms, but there are pronouns that are not pro-forms and pro-forms that are not pronouns
    case proform(PronounTag) // need ProformTag or a sub-category of pronoun?
    case pronoun(PronounTag) //
}

enum PrepositionTag { // IN
    
    case `in`
    case with
    case on
}

enum PrepositionalPhrase { // PP
    
    case temporal(PrepositionTag, NounPhrase)
    case locative
    case path
}

enum VerbTag {
    
    case pastTense(Verb)
    case presentTense(Verb)
    case presentTenseThirdPersonPlural(Verb)
    case presentParticiple(Verb) // G-Form
    case pastParticiple(Verb) // N-Form
}

// the main auxiliary verbs are to be, to have, and to do
enum AuxiliaryVerbTag {
    
    case tense  // was, is, will be, had, will have, had been, will have been
                // the aspect of the verb can also tell us things like whether the action is habitual, ongoing, or completed and is part of tense
    case mood   // Mood is the form a verb takes to show how it is to be regarded (e.g., as a fact, a command, a wish, an uncertainty).
                // indicative, imperative, subjunctive
    case voice  // voice is the term used to describe whether a verb is active or passive.
    case modal  // can, could, may, might, must, ought to, shall, should, will, and would
                // Modal auxiliary verbs combine with other verbs to express ideas such as necessity, possibility, intention, and ability
}

indirect enum VerbPhrase {
    
    case base(VerbTag)
    case auxiliary(AuxiliaryVerbTag, VerbPhrase) // can distransitive etc. be used on rhs?
    case distransitive(VerbTag, NounPhrase, NounPhrase)
}

enum SubordinateClause {
    
}

enum PreterminalNode {
    
    case pastTenseVerb
    case thirdPersonSingularPresentTenseVerb
    case nonThirdPersonSingularPresentTenseVerb
    case pastParticipla
    case pronoun
    case possessivePronoun
    case adjective
    case prepositon
    case complemenizer
    case determiner
}

enum TerminalNode {
    
    
}

let collectiveNouns: [CollectiveNoun] = ["family"]
let countableNouns: [CountableNoun] = ["map", "people"]
let uncountableNouns: [UncountableNoun] = ["news"]

let pluralisableNouns: [PluralisableNoun] = countableNouns.map { PluralisableNoun($0) }
    + collectiveNouns.map { PluralisableNoun($0) }

let nouns: [Noun] = pluralisableNouns.map { Noun($0) }
    + uncountableNouns.map { Noun($0) }

//let nouns: [Noun] = ["people", "history", "way", "art", "world", "information", "map", "two", "family", "government"]

// The majority are regular verbs, which means that “-d” or “-ed” is added to their base form (the infinitive of the verb without to) to create both the past simple tense and past participle.

struct Word: RawRepresentable, CustomStringConvertible {
    
    typealias RawValue = String
    
    var rawValue: String
    var description: String {
        
        return self.rawValue
    }
    
    init?(rawValue: String) {
        
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

//func +(left: Word, right: Word) -> Word {
//
//    return Word(stringLiteral: String(describing: left) + String(describing: right))
//}

// there are singular and uncountable nouns which have no plural e.g. physics, economics, news, athletics
// there are singular and countable nouns which have a plural e.g. bean, pea, bike, water
// there are collective nouns which are treated as singular e.g. team, family, class, union, army, committee

// all of NounTag, DeterminerTag, and PronounTag can be uncountable, countable or collective

struct CollectiveNoun {
    
    let singular: Word
    
    init(singular: Word) {
        
        self.singular = singular
    }
}

extension CollectiveNoun: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {

        self.singular = Word(stringLiteral: value)
    }
}


struct UncountableNoun {
    
    let singular: Word
    
    init(singular: Word) {
        
        self.singular = singular
    }
}

extension UncountableNoun: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {

        self.singular = Word(stringLiteral: value)
    }
}


struct CountableNoun {
    
    let singular: Word
    
    init(singular: Word) {
        
        self.singular = singular
    }
}

extension CountableNoun: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {

        self.singular = Word(stringLiteral: value)
    }
}


struct PluralisableNoun {

    private var _singular: (() -> Word)!
    
    var singular: Word { self._singular() }
    var plural: Word { Word(stringLiteral: "\(String(describing: self.singular))s") }

    init(_ countable: CountableNoun) {

        self._singular = { countable.singular }
    }

    init(_ collective: CollectiveNoun) {

        self._singular = { collective.singular }
    }
}


struct Noun {
    
    private var _singular: (() -> Word)!
    var singular: Word { self._singular() }
    
    init(_ pluralisable: PluralisableNoun) {

        self._singular = { pluralisable.singular }
    }

    init(_ uncountable: UncountableNoun) {

        self._singular = { uncountable.singular }
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

struct Infinitive: RawRepresentable, CustomStringConvertible {

    typealias RawValue = String

    var rawValue: String
    var description: String {

        return self.rawValue
    }

    init?(rawValue: String) {

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


struct RegularVerb {
                
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

let regularVerbs: [RegularVerb] = ["want", "look", "use", "panic", "chop", "copy"]

/*
 
 There are about 200 irregular verbs in English. We can divide these into four types:

     Verbs which have the same base form, past simple and past participle
     Verbs which have the same past simple and past participle
     Verbs which have the same base form and past participle
     Verbs which have a different base form, past simple and past participle
 */


/// have the same base form, past simple and past participle
struct IrregularVerb1 {
    
    let base: Word                                                  // cost
    var infinitive: Infinitive { Infinitive(base: self.base) }      // to cost
    var gerund: Word { Verb.formGerund(Verb(IrregularVerb(self))) }                // cost -ing
    var presentParticiple: Word { Verb.formPresent(Verb(IrregularVerb(self))) }    // cost -ing
    var pastParticiple: Word { self.base }                          // cost
    var simplePast: Word { self.base }                              // cost
}

extension IrregularVerb1: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {

        self = IrregularVerb1(base: Word(stringLiteral: value))
    }
}

/// have the same past simple and past participle
struct IrregularVerb2 {
    
    let base: Word                                                  // bring
    var infinitive: Infinitive { Infinitive(base: self.base) }      // to cost
    var gerund: Word { Verb.formGerund(Verb(IrregularVerb(self))) }                // cost -ing
    var presentParticiple: Word { Verb.formPresent(Verb(IrregularVerb(self))) }    // cost -ing
    var pastParticiple: Word { self.simplePast }                    // brought
    let simplePast: Word                                            // brought
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
struct IrregularVerb3 {
    
    let base: Word                                                              // come
    var infinitive: Infinitive { Infinitive(base: self.base) }                  // to cost
    var gerund: Word { Verb.formGerund(Verb(IrregularVerb(self))) }             // cost -ing
    var presentParticiple: Word { Verb.formPresent(Verb(IrregularVerb(self))) } // cost -ing
    var pastParticiple: Word { self.base }                                      // come
    let simplePast: Word                                                        // came
}

//extension IrregularVerb3: ExpressibleByStringLiteral {
//
//    public init(stringLiteral value: String) {
//
//        self = IrregularVerb3(base: Word(stringLiteral: value))
//    }
//}

/// have a different base form, past simple and past participle
struct IrregularVerb4 {
    
    let base: Word                                                  // begin
    var infinitive: Infinitive { Infinitive(base: self.base) }      // to cost
    var gerund: Word { Verb.formGerund(Verb(IrregularVerb(self))) }                // cost -ing
    var presentParticiple: Word { Verb.formPresent(Verb(IrregularVerb(self))) }    // cost -ing
    let pastParticiple: Word                                        // began
    let simplePast: Word                                            // begun
}

//extension IrregularVerb4: ExpressibleByStringLiteral {
//
//    public init(stringLiteral value: String) {
//
//        self = IrregularVerb4(base: Word(stringLiteral: value))
//    }
//}

struct IrregularVerb {

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

    init(_ irregular: IrregularVerb1) {

        self._base = { irregular.base }
        self._infinitive = { irregular.infinitive }
        self._gerund = { irregular.gerund }
        self._presentParticiple = { irregular.presentParticiple }
        self._pastParticiple = { irregular.pastParticiple }
        self._simplePast = { irregular.simplePast }
    }

    init(_ irregular: IrregularVerb2) {

        self._base = { irregular.base }
        self._infinitive = { irregular.infinitive }
        self._gerund = { irregular.gerund }
        self._presentParticiple = { irregular.presentParticiple }
        self._pastParticiple = { irregular.pastParticiple }
        self._simplePast = { irregular.simplePast }
    }

    init(_ irregular: IrregularVerb3) {

        self._base = { irregular.base }
        self._infinitive = { irregular.infinitive }
        self._gerund = { irregular.gerund }
        self._presentParticiple = { irregular.presentParticiple }
        self._pastParticiple = { irregular.pastParticiple }
        self._simplePast = { irregular.simplePast }
    }

    init(_ irregular: IrregularVerb4) {

        self._base = { irregular.base }
        self._infinitive = { irregular.infinitive }
        self._gerund = { irregular.gerund }
        self._presentParticiple = { irregular.presentParticiple }
        self._pastParticiple = { irregular.pastParticiple }
        self._simplePast = { irregular.simplePast }
    }
}


let irregular1Verbs: [IrregularVerb1] = ["cost", "cut", "hurt", "let", "put"]
let irregular2Verbs: [IrregularVerb2] = [IrregularVerb2(base: "bring", simplePast: "brought")
                                         , IrregularVerb2(base: "buy", simplePast: "bought")
                                         , IrregularVerb2(base: "catch", simplePast: "caught")
                                         , IrregularVerb2(base: "feel", simplePast: "felt")
                                         , IrregularVerb2(base: "find", simplePast: "found")]
let irregular3Verbs: [IrregularVerb3] = [IrregularVerb3(base: "come", simplePast: "came")
                                         , IrregularVerb3(base: "become", simplePast: "became")
                                         , IrregularVerb3(base: "run", simplePast: "ran")]
let irregular4Verbs: [IrregularVerb4] = [IrregularVerb4(base: "be", pastParticiple: "was/were", simplePast: "been")
                                         , IrregularVerb4(base: "begin", pastParticiple: "began", simplePast: "begun")
                                         , IrregularVerb4(base: "break", pastParticiple: "broke", simplePast: "broken")
                                         , IrregularVerb4(base: "choose", pastParticiple: "chose", simplePast: "chosen")
                                         , IrregularVerb4(base: "do", pastParticiple: "did", simplePast: "done")]

let irregularVerbs: [IrregularVerb] = irregular1Verbs.map { IrregularVerb($0) }
    + irregular2Verbs.map { IrregularVerb($0) }
    + irregular3Verbs.map { IrregularVerb($0) }
    + irregular4Verbs.map { IrregularVerb($0) }

struct Verb {
    
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
    
    init(_ regular: RegularVerb) {
        
        self._base = { regular.base }
        self._infinitive = { regular.infinitive }
        self._gerund = { regular.gerund }
        self._presentParticiple = { regular.presentParticiple }
        self._pastParticiple = { regular.pastParticiple }
        self._simplePast = { regular.simplePast }
        
        self.isIrregular = false
    }
    
    init(_ irregular: IrregularVerb) {

        self._base = { irregular.base }
        self._infinitive = { irregular.infinitive }
        self._gerund = { irregular.gerund }
        self._presentParticiple = { irregular.presentParticiple }
        self._pastParticiple = { irregular.pastParticiple }
        self._simplePast = { irregular.simplePast }

        self.isIrregular = true
    }
}

let verbs = regularVerbs.map { Verb($0) }
    + irregularVerbs.map { Verb($0) }

for verb in verbs {

    print("\(verb.base) \(verb.gerund) '\(verb.infinitive)' \(verb.presentParticiple) \(verb.pastParticiple) \(verb.simplePast)")
}

// indicative: present, preterite, future
// perfect: present, past, future
// continuous: present, past, future
// Continuous Perfect: present, past, future
// Conditional: present, perfect
// imperative



extension Sentence: CustomStringConvertible {

    var description: String {
    
        // no knowledge is transferred about the Sentence...
        // subject and verb must agree so need to be resolved together
        
        switch self {
        case .simple(let np, let vp, _):
            return "\(String(describing: np)) \(String(describing: vp))"
        }
    }
}

extension NounPhrase: CustomStringConvertible {
        
    var description: String {
    
        switch self {
        case .base(let tag):
            return String(describing: tag)
        case .isolation(let tag):
            return "determiner tag in isolation"
        case .determiner(let tag, let modifierTags, let nounTags):
            return "determiner..."
        case .proform(let tag):
            return "proform tag"
        case .pronoun(let tag):
            return "pronoun tag"
        }
    }
}

extension VerbPhrase: CustomStringConvertible {
        
    var description: String {
    
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

extension NounTag: CustomStringConvertible {
    
    var description: String {
        
        switch self {
        
        case .singularNoun(let noun):
            return String(describing: noun.singular)
        case .pluralNoun(let noun):
            return String(describing: noun.plural)
        case .properNoun:
            return "proper"
        case .pluralProperNoun:
            return "plural proper"
        }
    }
}

extension VerbTag: CustomStringConvertible {
    
    var description: String {
        
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

// coding .singularNoun of a CollectiveNoun such as 'family'
// the family runs... the families run
// an UncountableNoun such as 'news' has no plural so it would be wrong to handle this way
// a .singularNoun can take a CollectiveNoun, a CountableNoun and a UncountableNoun (any noun)
// where a .pluralNoun (tag) can take either a CollectiveNoun or a CountableNoun
// PluralisableNoun: CollectiveNoun or a CountableNoun (for both)
// Noun: PluralisableNoun or a UncountableNoun (only for .singularNoun)
let singularPresentTense = Sentence.simple(
    subject: .base(.singularNoun(Noun(PluralisableNoun(CountableNoun(stringLiteral: "people")))))
    , .base(.presentTense(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)

let singularPastTense = Sentence.simple(
    subject: .base(.singularNoun(Noun(PluralisableNoun(CountableNoun(stringLiteral: "people")))))
    , .base(.pastTense(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)

let singularPastParticiple = Sentence.simple(
    subject: .base(.singularNoun(Noun(PluralisableNoun(CountableNoun(stringLiteral: "people")))))
    , .base(.pastParticiple(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)

let singularPresentParticiple = Sentence.simple(
    subject: .base(.singularNoun(Noun(PluralisableNoun(CountableNoun(stringLiteral: "people")))))
    , .base(.presentParticiple(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)

let pluralPresentTense = Sentence.simple(
    subject: .base(.singularNoun(Noun(PluralisableNoun(CountableNoun(stringLiteral: "people")))))
    , .base(.pastParticiple(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)

let pluralPresentParticiple = Sentence.simple(
    subject: .base(.pluralNoun(PluralisableNoun(CountableNoun(stringLiteral: "people"))))
    , .base(.presentParticiple(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)



// Add an “s” to the verb if the subject is third-person singular (he, she, it, they, Martha, Sam, etc.). Do not add an “s” if the subject is plural.

// he walks, they walk, it walks
// a sentence has subject,verb and optional object
let foo = Sentence.simple(subject: .pronoun(.personal) // singular or plural?
                          , .base(.presentTense(Verb(RegularVerb(stringLiteral: "walk"))))
                          , object: nil)
