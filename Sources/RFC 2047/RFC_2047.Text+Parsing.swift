public import Byte

extension RFC_2047.Text {

    public init<Bytes: Swift.Collection>(_ bytes: Bytes) where Bytes.Element == Byte {
        let tokens = Self.tokens(Array(bytes))
        var segments: [RFC_2047.Text.Segment] = []
        for (index, token) in tokens.enumerated() {
            switch token {
            case .word(let word):
                segments.append(.word(word))
            case .text(let octets):
                segments.append(.text(octets))
            case .space(let octets):
                let between =
                    index > tokens.startIndex && index + 1 < tokens.endIndex
                    && tokens[index - 1].isWord && tokens[index + 1].isWord
                if !between { segments.append(.text(octets)) }
            }
        }
        self.init(segments: Self.merged(segments))
    }

    private static func tokens(_ bytes: [Byte]) -> [Token] {
        var tokens: [Token] = []
        var start = bytes.startIndex
        while start < bytes.endIndex {
            let space = isSpace(bytes[start])
            let end = bytes[start...].firstIndex { isSpace($0) != space } ?? bytes.endIndex
            let run = Array(bytes[start..<end])
            tokens.append(space ? .space(run) : token(run))
            start = end
        }
        return tokens
    }

    private static func token(_ run: [Byte]) -> Token {
        do throws(RFC_2047.EncodedWord.Error) {
            return .word(try RFC_2047.EncodedWord(ascii: run))
        } catch {
            return .text(run)
        }
    }

    private static func isSpace(_ byte: Byte) -> Bool {
        switch byte.bitPattern {
        case 0x20, 0x09, 0x0D, 0x0A: true
        default: false
        }
    }

    private static func merged(_ segments: [RFC_2047.Text.Segment]) -> [RFC_2047.Text.Segment] {
        segments.reduce(into: []) { result, segment in
            switch (result.last, segment) {
            case (.text(let previous)?, .text(let next)):
                result[result.count - 1] = .text(previous + next)
            default:
                result.append(segment)
            }
        }
    }
}
