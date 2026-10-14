public import Byte

extension RFC_2047.EncodedWord {

    public var octets: [Byte] {
        get throws(Error) {
            try encoding.decode(text)
        }
    }
}
