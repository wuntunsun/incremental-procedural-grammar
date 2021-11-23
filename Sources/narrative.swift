import Foundation





// the foundation of each sentence is the subject and the predicate. The subject is a word or a group of words that functions as a noun; the predicate is at least a verb and possibly includes objects and modifiers of the verb.
// The grammaticality of a sentence depends not on the sequence of words but how the words are combined into phrases.
// Given-Before-New Principle.. subject is 'given' information, predicate is 'new' information.

// there is also the idea of end-weight https://www.thoughtco.com/end-weight-grammar-1690594
// whereby the subject should be shorter than the predicate...

//Narrative is the structure of events — the architecture of the story, comparable to the design of a building. Story is the sequence of events, the order in which the narrative occurs — the tour through the building. Plot is the sum of the events, told not necessarily in sequential order, but generally consistent with the story and often considered synonymous with the narrative — the building itself.

public struct Narrative {
 
    public struct Event {
        
        public init() {
            
        }
    }

    public struct Location {
        
        let name: ProperNoun
        
        public init(name: ProperNoun) {
            
            self.name = name
        }
    }

    // later -> later -> that_evening -> (that_morning)
    // later -> later -> next_day
    // later -> later -> next_afternoon -> next_day -> next_morning (each next advances a day)

    public enum TemporalRelationship {
        
        case later
        case next_day
        case next_morning
        case next_afternoon
        case next_evening
        case next_night
    }

    public enum LocationRelationship {
        
        case nextdoor
    }

    // Daytime: Morning · Noon · Afternoon · Evening
    // Twilight: Dawn · Sunrise · Sunset · Dusk
    // Night: Midnight · Witching hour · Brahmamuhurtha

    public struct Beat {
        
        public init() {
            
        }
    }
    
    // Our lives are made up of scenes and sequels... scenes are where characters 'act', sequels where they 'react'...
    // a scene takes place at a certain place and time
    // multiple scenes can take place at the same time, but with different characters
    public enum Scene {
        
        // Depending on the Scene structure, Parts are spread around Scenes...
        enum Part {
            
            // .action
            case goal
            case conflict
            case disaster
            // .sequel
            case reaction
            case dilemma
            case decision
        }
        
        case action(Event)
        case sequel
        
        static func scene(from: Narrative, given: Given) -> Scene {

            // TODO: what is a Beat?
            // TODO: generate goal, conflict and disaster
            let event = Event()
            return Scene.action(event)
        }

        static func sequel(from: Narrative, given: Given) -> Scene {
            
            // TODO: generate reaction, dilemma and disaster
            return Scene.sequel
        }
    }

    struct Given {
        
        var characters: [Character]
        var location: Location
        var act: Act.Part
        
        // TODO: should we know how far we are through the act???
        init(characters: [Character], location: Location, act: Act.Part) {
            
            self.characters = characters
            self.location = location
            self.act = act
        }
    }
    
    // any number of scenes and sequels put in temporal order to each other
    // a sequence must have at least one scene or sequel...
    // given the location, a season may have change... where is it winter?
    // 50 scenes to 20 sequels... or not :-)
    public enum Sequence {
        
        case opening(Event)
        indirect case later(Sequence, TemporalRelationship, Scene)
        indirect case elsewhere(Sequence, LocationRelationship, Scene)
        
        // Sequence per Act, Part, Chapter, Section, Subsection, Paragraph, Subparagraph
        // An Act can have multiple Parts
        // A Part will have multiple Chapters
        // A Chapter could contain multiple Scenes.
        // Chapters can indicate many things, it is unusual to change POV mid chapter for instance
        // Chapter is really the last narrative element...
        // Scenes with multiple characters...
        // A Beat is a point of inflection/change...
        static func sequence(from: Narrative, act: Act.Part, character: Character) -> Sequence {
            
            // to make a scene we need an Event...
            // we may involve other characters...
            // case goal, case conflict, case disaster
            
            let event = Event()
            let opening = Sequence.opening(event)

            // TODO: generate multiple scenes...
            
            let characters: [Character] = [character]
            let location = Location(name: ProperNoun(name: "Station", personalPronoun: .it))
            let given = Given(characters: characters
                              , location: location
                              , act: act)
            let scene = Scene.scene(from: from, given: given)
            
            return .later(opening, .next_day, scene)
        }
    }
      
    public struct Character: Hashable {
        
        public enum Role {
            
            case protagonist
            case antagonist
            case dynamic
            case `static`
        }
        
        let role: Role
        let name: ProperNoun
        
        public static func == (lhs: Character, rhs: Character) -> Bool {
        
            guard lhs.role == rhs.role else { return false }
            guard lhs.name == rhs.name else { return false }
            
            return true
        }
        
        public init(role: Role, name: ProperNoun) {
            
            self.role = role
            self.name = name
        }
    }

    // An Act will have a Sequence per Character, usually a Protagonist or an Antagonist
    // other characters can be mentioned in a sequence associated
    public struct Act {

        // Depending on the Plot structure, Parts are spread around Acts...
        public enum Part {
            
            case introduction
            case risingAction
            case climax
            case fallingAction
            case conclusion
        }
        
        var sequences: [Character: Sequence] = [:]
        
        public init(sequences: [Character: Sequence] = [:]) {
            
            self.sequences = sequences
        }
        
        mutating func beat(from: Narrative, given: Given) {
            
            // new or existing Characters?
            
            // for each character
            //Sequence.sequence(from: from, act: act, character: <#T##Narrative.Character#>)
            
            // new or existing Characters?
            // Scene or Sequel?
            //
            
            // TODO: which characters appear in this Act?
        }
    }

    public enum Plot {
        
        case three(Act, Act, Act)
        case four(Act, Act, Act, Act)
    }

    // Backdrop vs integral setting whereby only the latter affects the plot.
    public enum Setting {
        
        case backdrop
        case integral
    }
    
    let setting: Setting
    let plot: Plot
    
    let story: [Event] = [] // do I need this?
    var characters: [Character]
    var locations: [Location]
    
    public init(setting: Setting, plot: Plot, characters: [Character] = [], locations: [Location] = []) {
        
        self.setting = setting
        self.plot = plot
        self.characters = characters
        self.locations = locations
    }
        
    func beat(given: Given) -> [Character: Sequence] {

        // which Act?
        // which Character or Characters
        // create or pick up Sequence per Character (with POV)
        // group characters, then call beat on each one to advance by a Scene or Sequel
    }
    
    var given: Given? {
        
        let location = Location(name: ProperNoun())
        return Given(characters: []
                     , location: Location(name: ProperNoun())
                     , act: Act.Part.introduction)
    }
    
    // how to push the story along
    // new event, change location
    // continue event
    mutating func write() {
        
        if let given = self.given {
            
            let story = self.beat(given: given)
            //let characters = story
        }
        
        // we need a Given?
        // the Given is where we are in the Narrative
        // it includes the Act.Part i.e. introduction, risingAction etc.
        // but maybe it comes from the Narrative as well
        //
        
        // \part[<short title>]{<title>}
        // \chapter[<short title>]{<title>}
        // \section[<short title>]{<title>}
        // \subsection[<short title>]{<title>}
        // \subsubsection[<short title>]{<title>}
        // \paragraph[<short title>]{<title>}
        // \subparagraph[<short title>]{<title>}
        
        // 1 .protagonist
        // 1 .antagonist
        // N .dynamic
        // N .static
        
        // N Scene per Act
        // dependent on the plot, generate Act.Part within each Act
        // each Scene needs a
        
        // the narrative drives the current Act on beat by beat
    }
    
    // provide given for reference and generate new...
    // the given is the Subject which will be represented by a NounPhrase
    // but the Subject collects many details that may or may not be used in the Sentence
    // events can repeat leading to a 'fact' about a subject e.g. a person is clumsy if they break a lot of stuff
    // this should lead to a periodic event that may or may not be plot relevant
    // also key relational events between subjects
    // which leads us to a simulation of events...
    // location changes; how do people transition?
    // time changes; how much?
    
    // Subject–Verb
    // Subject–Verb–Object
    // Subject–Verb–Adjective
    // Subject–Verb–Adverb
    // Subject–Verb–Noun
    
    // Given an algebraic type, we would have to use reflection to decide what to do next, or to randomly
    // choose from allCases. The use of allCases would be tricky for enums with associated values as these
    // would need to generate content as well. A more refined version of CaseIterable may be the answer.
    // Having said that, the choice between a singular or a plural noun (taking the NounTag) example should
    // already have been met.
    
    // The alternative may be to encode the rules of the language in Narrative, or to have a separate process
    // that decides on the elements of the narrative before combining them to the syntax. This is then not
    // data driven; the narrative still stems from the rules of the language, but they are coded differently.

    // How can one apply rules when formulating the sentences?
    // Given an unorded collection of semantic elements, possibly related, apply rules to order, and then form senstences.
    // We will still have Subject, Object etc.
    // We need to know what is 'given' and what is 'new'
    // Each sentence has subject and predicate, the type of sentence is the result of multiple subjects and predicates
    // in relation to each other.
    // Within a paragraph we will introduce a Subject e.g. Samuel and Liam fought over some pudding. The subject
    // is then 'given' and can be referred to with a pronoun i.e. 'they' when continuing the narrative.
    // The above has multiple ProperNouns signifying subjects with a given PersonalPronoun, and 'pudding' as an
    // UncountableNoun (it can also be a CountableNoun) signifiying the DirectObject in the Predicate. We want to
    // narrate that they 'fought', but they could also have 'shared' the 'pudding'.
    // Story is the causality of events, plot is the 'narrative', possibly in acts, that dramatize the story e.g.
    // introduction, rising action, climax, falling action and conclusion.
    // The plot order may not match the story order.
    // The verb 'shared' is a story verb, whereas 'fought' is a plot verb...
    // The story will be a succession of locations,
    
    // Protagonist: The main character whose journey we follow throughout the story
    // Antagonist: Sometimes known as the foil, the character whose goals come up against the protagonist's, leading to conflict
    // Dynamic Character: A character who changes as a result of the events in the story
    // Static Character: A character who does not change during the course of a story
    // Possibly more words such as Rival which associate any two characters.
    
    // If there is no 'given' then it must be created...
    // The 'given' grows as we narrate...
    // The 'given' consists of, possibly, muliple protagonists (although most stories have one).
    // For each protagonist there should be a story arc, each arc should meet possibly several times.
    // Personality traits are easily tangible, whereas character traits may only reveal themselves over time.
    // https://examples.yourdictionary.com/character-trait-examples.html
    // A Chapter has a typical length, possibly joining multiple 'nearby' locations that have an association e.g. the
    // same characters are together.
    
    // The point where the protagonist's and antagonist's interests collide is the conflict; internal vs external
    
    // During the first 'exposition' we usually introduce the protagonist, the antagonist and early secondary dynamic and
    // static characters. A protagaonist will be 'given' or created... as will the other characters.
    // Postulate nothing more than the events of the story... which will be actions aka verbs.
    // Story 1:N Event 1:N Action (although Actions are transient).
    // An Event has location, characters,
}
