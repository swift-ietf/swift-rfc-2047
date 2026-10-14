public import Byte

extension RFC_2047.Text {

    public enum Segment: Sendable, Hashable {

        case text([Byte])

        case word(RFC_2047.EncodedWord)
    }
}
