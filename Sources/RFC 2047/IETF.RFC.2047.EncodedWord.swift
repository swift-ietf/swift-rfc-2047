public import ASCII
public import RFC_2045

extension IETF.RFC.`2047` {

    public struct EncodedWord: Sendable, Hashable {

        public let charset: IETF.RFC.`2045`.Charset

        public let encoding: IETF.RFC.`2047`.Encoding

        public let text: [ASCII.Code]

        public init(
            charset: IETF.RFC.`2045`.Charset,
            encoding: IETF.RFC.`2047`.Encoding,
            text: [ASCII.Code]
        ) {
            self.charset = charset
            self.encoding = encoding
            self.text = text
        }
    }
}
