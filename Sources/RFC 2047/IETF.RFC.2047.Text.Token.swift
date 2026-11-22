import Byte

extension IETF.RFC.`2047`.Text {

    enum Token {

        case space([Byte])

        case text([Byte])

        case word(IETF.RFC.`2047`.EncodedWord)
    }
}

extension IETF.RFC.`2047`.Text.Token {

    var isWord: Bool {
        switch self {
        case .word: true
        case .space, .text: false
        }
    }
}
