import Foundation

// https://en.m.wikipedia.org/wiki/Noun_adjunct
// Noun adjuncts were traditionally mostly singular (e.g. "trouser press") except when there were lexical restrictions (e.g. "arms race")
//  arm race vs arms race, arms is used as a collective noun instead of weapons...
// There are morphologic restrictions on the classes of adjunct that can be plural and nonpossessive; irregular plurals are solecistic as nonpossessive adjuncts:
//  (for example, "men clothing" or "women magazine" sound improper to fluent speakers).
// this is more of a noun thing...
// chicken soup, railroad, train tracks...

// ModifiedNoun
// California is a ProperNoun, "northwestern California" is a CompoundNoun
// "a northwestern California landmark" uses the same CompoundNoun as a 'modifier' for the PluralisableNoun "landmark"

public enum NounPhrase { // NP
    
    case base(NounTag)
    case isolation(DeterminerUsableInIsolation)
    case indefinite([Adjective], [NounTag], Noun) // TODO: CompoundNoun?, a modifier can be a compound e.g. "northwestern California"
    case determiner(Determiner, [Adjective], [NounTag], NounTag) // https://dictionary.cambridge.org/grammar/british-grammar/adjectives-order
    // A pro-form is a type of function word or expression that stands in for (expresses the same content as) another word, phrase, clause or sentence where the meaning is recoverable from the context.[4] In English, pronouns mostly function as pro-forms, but there are pronouns that are not pro-forms and pro-forms that are not pronouns
    case proform(PronounTag) // need ProformTag or a sub-category of pronoun?
    case pronoun(PronounTag) //
    
    static func determination(tag: Determiner, nounTag: NounTag) -> String {
        
        switch tag {
            
        case .definite:
            return "the \(String(describing: nounTag))"
        case .proximal:
            assert(false)
        case .distal:
            assert(false)
        case .possessive:
            assert(false)
        case .quantifier:
            assert(false)
        case .distributive:
            assert(false)
        }
    }
}

extension NounPhrase: CustomStringConvertible {
    
    public var description: String {
    
        switch self {
        case .base(let tag):
            return String(describing: tag)
        case .isolation(let tag):
            return String(describing: tag)
        case .indefinite(let modifierTags, let adjunctNouns, let noun):
            // TODO: an...
            return "a \(String(describing: NounTag.singularNoun(noun)))"
        case .determiner(let tag, let adjectives, let adjunctNouns, let nounTag):
            // TODO: modifierTags and nounTags
            return NounPhrase.determination(tag: tag, nounTag: nounTag)
        case .proform(let tag):
            assert(false)
        case .pronoun(let tag):
            return String(describing: tag)
        }
    }
}

/*
 
 A proper noun is a noun that identifies a single entity and is used to refer to that entity, such as London, Jupiter, Sarah, or Microsoft, as distinguished from a common noun, which is a noun that refers to a class of entities (city, planet, person, corporation) and may be used when referring to instances of a specific class (a city, another planet, these persons, our corporation).[1][2][3][4] Some proper nouns occur in plural form (optionally or exclusively), and then they refer to groups of entities considered as unique (the Hendersons, the Everglades, the Azores, the Pleiades). Proper nouns can also occur in secondary applications, for example modifying nouns (the Mozart experience; his Azores adventure), or in the role of common nouns (he's no Pavarotti; a few would-be Napoleons). The detailed definition of the term is problematic and, to an extent, governed by convention
*/

public enum NounTag {
    
    // handle countable/uncountable...
    // properNoun, properName (phrase)
    
    case singularNoun(Noun)             // NN
    case pluralNoun(PluralisableNoun)   // NNS
    case properNoun         // NNP
    case pluralProperNoun   // NNPS
}

extension NounTag: CustomStringConvertible {
    
    public var description: String {
        
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

// there are singular and uncountable nouns which have no plural e.g. physics, economics, news, athletics
// there are singular and countable nouns which have a plural e.g. bean, pea, bike, water
// there are collective nouns which are treated as singular e.g. team, family, class, union, army, committee
// there are proper nouns which identify a particular person, place, or thing, e.g. Steven, Africa, London, Monday. In written English, proper nouns begin with capital letters.
// all of NounTag, DeterminerTag, and PronounTag can be uncountable, countable or collective

// a school law review DT [NN NN] NN
// an English count noun can be used in a mass noun grammatical context, as in There was a huge Buick there; just acres of car (attested example). The noun car, normally denoting an individuatable object, is construed to denote an unbounded quality (size).
// For example, the meaning of over in The bird flew over the hill (path of motion) is distinct from its meaning in The house is over the hill (location), but they are related systematically. More specifically, cognitive linguists (drawing on research by psychologists) have suggested that many polysemous categories have one meaning that can be considered central or basic, called the category's prototype.
// the linguistic structuring of basic conceptual categories such as space and time, scenes and events, entities and processes, motion and location, and force and causation. To these it adds basic categories of cognition such as attention and perspective, volition and intention, and expectation and affect. It addresses the interrelationships of conceptual structures, such as those in metaphoric mapping, those within a semantic frame, those between text and context, and those in the grouping of conceptual categories into large structuring systems

// Over can be used in the following ways:
// as a preposition (followed by a noun or a pronoun): a bridge over the river Two men were fighting over her. (followed by a number or amount): It happened over a hundred years ago.
// as an adverb (without a following noun): He fell over and broke his arm.
// after the verb ‘to be’: The semester will be over soon.

// subject:[The bird] verb:[flew] preposition:{path of motion}[over] object:[the hill]
// subject:[The house] verb:[is] preposition:{location}[over] object:[the hill]

// verbs and prepositions suited to {path of motUncountableNounion}, {location} etc.
// words can belong to multiple semantic categories

public struct CollectiveNoun {
    
    let singular: Word
    
    public init(singular: Word) {
        
        self.singular = singular
    }
}

extension CollectiveNoun: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {

        self.singular = Word(stringLiteral: value)
    }
}


public struct UncountableNoun {
    
    let singular: Word
    
    public init(singular: Word) {
        
        self.singular = singular
    }
}

extension UncountableNoun: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {

        self.singular = Word(stringLiteral: value)
    }
}


public struct CountableNoun {
    
    let singular: Word
    
    public init(singular: Word) {
        
        self.singular = singular
    }
}

extension CountableNoun: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {

        self.singular = Word(stringLiteral: value)
    }
}


/// person, place or thing
public struct ProperNoun: Hashable {
  
    public static func == (lhs: ProperNoun, rhs: ProperNoun) -> Bool {
        
        guard lhs.name == rhs.name else { return false }
        guard lhs.personalPronoun == rhs.personalPronoun else { return false }
        
        return true
    }
    
    let name: Word
    let personalPronoun: PersonalPronoun
    
    public init(name: Word, personalPronoun: PersonalPronoun) {
        
        self.name = name
        self.personalPronoun = personalPronoun
    }
}

                                                  
public struct PluralisableNoun {

    private var _singular: (() -> Word)!
    
    var singular: Word { self._singular() }
    var plural: Word { Word(stringLiteral: "\(String(describing: self.singular))s") }

    public init(_ countable: CountableNoun) {

        self._singular = { countable.singular }
    }

    public init(_ collective: CollectiveNoun) {

        self._singular = { collective.singular }
    }
}


public struct Noun {
    
    private var _singular: (() -> Word)!
    var singular: Word { self._singular() }
    
    public init(_ pluralisable: PluralisableNoun) {

        self._singular = { pluralisable.singular }
    }

    public init(_ uncountable: UncountableNoun) {

        self._singular = { uncountable.singular }
    }
    
    // TODO: more types of Noun...
}

/*
 Case and number distinctions do not apply to all pronoun types. In fact, they apply only to personal pronouns, possessive pronouns, and reflexive pronouns. It is only in these types, too, that gender differences are shown (personal he/she, possessive his/hers, reflexive himself/herself). All other types are unvarying in their form.

 Many of the pronouns listed above also belong to another word class - the class of determiners. They are pronouns when they occur independently, that is, without a noun following them, as in This is a new car. But when a noun follows them - This car is new - they are determiners. We will look at determiners in the next section.

 A major difference between pronouns and nouns generally is that pronouns do not take the or a/an before them. Further, pronouns do not take adjectives before them, except in very restricted constructions involving some indefinite pronouns (a little something, a certain someone).
 */

// the subject of a sentence is any NounPhrase
// which can be a

public enum PronounTag: CustomStringConvertible {
    
    // in the case of a noun, the noun iteself may be pluralisable
    // with a pronoun, it affects the verb
    // rather than a modifier, it is an attribute of the pronoun itself
    
    case personal(ProperNoun) // [SUBJECTIVE CASE] I, you, he/she/it... we, you, they... [OBJECTIVE CASE] me, you, him/her/it... us, you, them
    case possessive // mine, yours, his, hers, ours, theirs
    case reflexive  // myself, yourself, himself, herself, itself, oneself, ourselves, yourselves, themselves
    case reciprocal // each other, one another
    case demonstrative  // this, that, these, those
    case relative   // that, which, who, whose, whom, where, when
    case interrogative  // who, what, why, where, when, whatever
    case indefinite // anything, anybody, anyone, something, somebody, someone, nothing, nobody, none, no one
    
    public var description: String {
        
        switch self {
            
        case .personal(let properNoun):
            return String(describing: properNoun.personalPronoun)
        default:
            return "pronoun tag"
        }
    }
}

public enum PersonalPronoun: CustomStringConvertible {
    
    case i
    case he
    case she
    case it
    case they
    
    public var description: String {
        
        switch self {
            
        case .i:
            return "I"
        case .he:
            return "he"
        case .she:
            return "she"
        case .it:
            return "it"
        case .they:
            return "they"
        }
    }
}
