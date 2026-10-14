public import ASCII
public import RFC_2045

extension RFC_2047 {

    public struct EncodedWord: Sendable, Hashable {

        public let charset: RFC_2045.Charset

        public let encoding: RFC_2047.Encoding

        public let text: [ASCII.Code]

        public init(
            charset: RFC_2045.Charset,
            encoding: RFC_2047.Encoding,
            text: [ASCII.Code]
        ) {
            self.charset = charset
            self.encoding = encoding
            self.text = text
        }
    }
}
