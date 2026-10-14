extension RFC_2047.EncodedWord {

    public enum Error: Swift.Error, Sendable, Equatable {

        case notASCII

        case missingDelimiters

        case malformedStructure

        case invalidCharset

        case unknownEncoding

        case invalidText

        case invalidBase64

        case invalidQuotedOctet
    }
}
