import Foundation

func getOneline(_ string: String) {
    let lines = string.split(whereSeparator: {$0.isNewline})
    let result = lines
        .joined(separator: "\\n")
        .replacingOccurrences(of: "\"", with: "\\\("\"")")
    print(result)
}
let string = """
1. What inspired you to write science fiction?
2. What themes do you typically explore in your work?
3. How has the genre of science fiction evolved over time?
4. What do you think sets your work apart from other science fiction authors?
5. What advice would you give to aspiring science fiction authors?
6. What are some of the most challenging aspects of writing science fiction?
7. How has your writing process changed over the years?
8. What do you think is the most important thing for readers to take away from your work?
"""
getOneline(string)
