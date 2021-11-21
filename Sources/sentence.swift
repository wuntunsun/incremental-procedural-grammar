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

public enum Sentence: CustomStringConvertible {
    
    case simple(subject: NounPhrase, verb: VerbPhrase, object: NounPhrase?)
    
    public var description: String {
    
        // no knowledge is transferred about the Sentence...
        // subject and verb must agree so need to be resolved together
        // the resolution must happen here
        // extract the knowledge from the np to apply to the vp
        // if third person singular, present tense, add an s...
        
        switch self {
        case .simple(let subject, let verb, .some(let object)):
            return Subject.isThirdPersonSingular(subject) && Verb.isPresentTense(verb)
            ? "\(String(describing: subject)) \(String(describing: verb))s \(String(describing: object))"
            : "\(String(describing: subject)) \(String(describing: verb)) \(String(describing: object))"
        case .simple(let subject, let verb, .none):
            return Subject.isThirdPersonSingular(subject) && Verb.isPresentTense(verb)
            ? "\(String(describing: subject)) \(String(describing: verb))s"
            : "\(String(describing: subject)) \(String(describing: verb))"
        }
    }
}


public struct Subject {

    static func isThirdPersonSingular(_ personalPronoun: PersonalPronoun) -> Bool {
        
        switch personalPronoun {
        case .he,.she, .it:
            return true
        default:
            return false
        }
    }

    static func isThirdPersonSingular(_ pronounTag: PronounTag) -> Bool {
        
        switch pronounTag {
            
        case .personal(let properNoun):
            return Subject.isThirdPersonSingular(properNoun.personalPronoun)
        default:
            return false
        }
    }

    static func isThirdPersonSingular(_ nounPhrase: NounPhrase) -> Bool {
        
        switch nounPhrase {
            
        case .pronoun(let pronounTag):
            return Subject.isThirdPersonSingular(pronounTag)
        default:
            return false
        }
    }
}
