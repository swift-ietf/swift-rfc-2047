public import Byte

extension IETF.RFC.`2047`.Text {

    public enum Segment: Sendable, Hashable {

        case text([Byte])

        case word(IETF.RFC.`2047`.EncodedWord)
    }
}
