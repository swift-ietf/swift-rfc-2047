import Byte

extension RFC_2047.Text {

    enum Token {

        case space([Byte])

        case text([Byte])

        case word(RFC_2047.EncodedWord)
    }
}

extension RFC_2047.Text.Token {

    var isWord: Bool {
        switch self {
        case .word: true
        case .space, .text: false
        }
    }
}
