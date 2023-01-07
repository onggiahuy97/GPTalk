import NaturalLanguage
import CoreLocation

let text = "\""
//let text = "The American Red Cross was established in Washington, D.C., by Clara Barton."

let tagger = NLTagger(tagSchemes: [.nameType])
tagger.string = text

let options: NLTagger.Options = [.joinNames]
let tags: [NLTag] = [.personalName, .placeName, .organizationName]

var set = [NLTag: [String]]()

tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
    if let tag = tag, tags.contains(tag) {
        print("\(text[tokenRange]): \(tag.rawValue)")
        let name = "\(text[tokenRange])"
        if let names = set[tag], !names.contains(where: { $0 == name }) {
            set[tag] = names + [name]
        } else {
            set[tag] = [name]
        }
    }
    
    // Get multiple possible tags with their associated confidence scores.
//    let (hypotheses, range) = tagger.tagHypotheses(at: tokenRange.lowerBound, unit: .word, scheme: .nameType, maximumCount: 1)
//    print(hypotheses, "\(text[range])")
    return true
}


set.forEach { (key, value) in
    print(key, value)
}
