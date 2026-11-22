public import Byte

extension IETF.RFC.`2047`.EncodedWord {

    public var octets: [Byte] {
        get throws(Error) {
            try encoding.decode(text)
        }
    }
}
