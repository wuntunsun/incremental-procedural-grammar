import Foundation

let steven = ProperNoun(name: "Steven", personalPronoun: .he)
let kick = Verb(RegularVerb(stringLiteral: "kick"))
let drink = Verb(IrregularVerb(IrregularVerb2(base: "drink", simplePast: "drank")))
let ball = PluralisableNoun(CountableNoun(stringLiteral: "ball"))
let water = UncountableNoun(stringLiteral: "water")

let heKickedTheBalls = Sentence.simple(
    subject: .pronoun(.personal(steven))
    , verb: .base(.pastTense(kick))
    , object: .determiner(.definite, [], [], .pluralNoun(ball)))

let heKickedaBall = Sentence.simple(
    subject: .pronoun(.personal(steven))
    , verb: .base(.pastTense(kick))
    , object: .indefinite([], [], Noun(ball)))

let heKickedMany = Sentence.simple(
    subject: .pronoun(.personal(steven))
    , verb: .base(.pastTense(kick))
    , object: .isolation(.many))

let heDrankWater = Sentence.simple(
    subject: .pronoun(.personal(steven))
    , verb: .base(.pastTense(drink))
    , object: .base(.singularNoun(Noun(water))))

let allDrink = Sentence.simple(
    subject: .isolation(.all)
    , verb: .base(.presentTense(drink))
    , object: nil)


// subject to the natural ordering of i.e. http://englishrefresher.blogspot.com/2011/08/proper-order-of-modifiers.html
struct NounGroup {
    
    // having a Set declares the input as unordered
    // using an algebraic type does not encode the rules i.e. any generator would need to know what can come next
    // making it context free..
    // in this context they can be adjectives
    // the sum type Sentence has multiple cases, a higher order call can choose between them; there may be a mapping
    // between the case and a narrative goal.
    // The original idea was to simply choose the next word, according to the rules of English, and to build up context while doing this...
    
    // noun, adjectival clause
    // subject, adjectival phrase, verb object
    
    //var modifiers: Set<>
    var noun: Noun
}

// determiner, n adjectives, noun
// there will be a stack to handle phrases and sub-sentences
// it will also pick plural etc.
// it may not be on a word for word basis

// they all drank
// determiner adverb:modifier verb

// The two principal types of modifiers are adjectives (and adjectival phrases and adjectival clauses), which modify nouns; and adverbs (and adverbial phrases and adverbial clauses), which modify other parts of speech, particularly verbs, adjectives and other adverbs, as well as whole phrases or clauses. (Not all adjectives and adverbs are necessarily modifiers, however; an adjective will normally be considered a modifier when used attributively, but not when used predicatively – compare the examples with the adjective red at the start of this article.)

// Another type of modifier in some languages, including English, is the noun adjunct, which is a noun modifying another noun (or occasionally another part of speech). An example is land in the phrase land mines given above.

// He painted her sitting on the step
// 'sitting on the step' can modify her, or he, or painted her, or he painted her

let opening: Narrative.Sequence = .opening(Narrative.Event())
let sequel: Narrative.Sequence = .later(.opening(Narrative.Event()), .later, .sequel)
let foo: Narrative.Sequence = .elsewhere(.later(.opening(Narrative.Event()), .later, .sequel), .nextdoor, .action(Narrative.Event()))

let steve = Narrative.Character(role: .protagonist, name: ProperNoun(name: "Steve", personalPronoun: .he))
let sequence1: Narrative.Sequence = .opening(Narrative.Event())
let act1 = Narrative.Act(sequences: [steve : sequence1])

let narrative = Narrative(setting: .backdrop
                          , plot: .three(Narrative.Act(), Narrative.Act(), Narrative.Act()))

// there are singular and uncountable nouns which have no plural e.g. physics, economics, news, athletics
// there are singular and countable nouns which have a plural e.g. bean, pea, bike, water
// there are collective nouns which are treated as singular e.g. team, family, class, union, army, committee

// all of NounTag, DeterminerTag, and PronounTag can be uncountable, countable or collective

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
let properNouns: [ProperNoun] = [ProperNoun(name: "Steven", personalPronoun: .he)
                                 , ProperNoun(name: "Africa", personalPronoun: .it)
                                 , ProperNoun(name: "London", personalPronoun: .it)
                                 , ProperNoun(name: "Monday", personalPronoun: .it)]

let pluralisableNouns: [PluralisableNoun] = countableNouns.map { PluralisableNoun($0) }
    + collectiveNouns.map { PluralisableNoun($0) }

let nouns: [Noun] = pluralisableNouns.map { Noun($0) }
    + uncountableNouns.map { Noun($0) }

//let nouns: [Noun] = ["people", "history", "way", "art", "world", "information", "map", "two", "family", "government"]

// The majority are regular verbs, which means that “-d” or “-ed” is added to their base form (the infinitive of the verb without to) to create both the past simple tense and past participle.

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

let regularVerbs: [RegularVerb] = ["want", "look", "use", "panic", "chop", "copy"]

let verbs = regularVerbs.map { Verb($0) }
    + irregularVerbs.map { Verb($0) }

//for verb in verbs {
//
//    print("\(verb.base) \(verb.gerund) '\(verb.infinitive)' \(verb.presentParticiple) \(verb.pastParticiple) \(verb.simplePast)")
//}

// indicative: present, preterite, future
// perfect: present, past, future
// continuous: present, past, future
// Continuous Perfect: present, past, future
// Conditional: present, perfect
// imperative


// coding .singularNoun of a CollectiveNoun such as 'family'
// the family runs... the families run
// an UncountableNoun such as 'news' has no plural so it would be wrong to handle this way
// a .singularNoun can take a CollectiveNoun, a CountableNoun and a UncountableNoun (any noun)
// where a .pluralNoun (tag) can take either a CollectiveNoun or a CountableNoun
// PluralisableNoun: CollectiveNoun or a CountableNoun (for both)
// Noun: PluralisableNoun or a UncountableNoun (only for .singularNoun)
let singularPresentTense = Sentence.simple(
    subject: .base(.singularNoun(Noun(PluralisableNoun(CountableNoun(stringLiteral: "people")))))
    , verb: .base(.presentTense(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)

let singularPastTense = Sentence.simple(
    subject: .base(.singularNoun(Noun(PluralisableNoun(CountableNoun(stringLiteral: "people")))))
    , verb: .base(.pastTense(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)

let singularPastParticiple = Sentence.simple(
    subject: .base(.singularNoun(Noun(PluralisableNoun(CountableNoun(stringLiteral: "people")))))
    , verb: .base(.pastParticiple(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)

let singularPresentParticiple = Sentence.simple(
    subject: .base(.singularNoun(Noun(PluralisableNoun(CountableNoun(stringLiteral: "people")))))
    , verb: .base(.presentParticiple(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)

let pluralPresentTense = Sentence.simple(
    subject: .base(.singularNoun(Noun(PluralisableNoun(CountableNoun(stringLiteral: "people")))))
    , verb: .base(.pastParticiple(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)

let pluralPresentParticiple = Sentence.simple(
    subject: .base(.pluralNoun(PluralisableNoun(CountableNoun(stringLiteral: "people"))))
    , verb:  .base(.presentParticiple(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)

let theyWalked = Sentence.simple(
    subject: .pronoun(.personal(ProperNoun(name: "Steven", personalPronoun: .they)))
    , verb: .base(.pastTense(Verb(RegularVerb(stringLiteral: "walk"))))
    , object: nil)


