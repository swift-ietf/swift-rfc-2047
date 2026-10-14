import Byte
import RFC_2045
import RFC_2047
import Testing

extension RFC_2047.EncodedWord {

    @Suite
    struct Test {

        @Suite
        struct Unit {}

        @Suite
        struct `Edge Case` {}
    }
}

extension RFC_2047.EncodedWord.Test.Unit {

    @Test
    func `a Q encoded word decodes underscores to spaces`() throws {
        let word = try RFC_2047.EncodedWord("=?US-ASCII?Q?Keith_Moore?=")

        #expect(word.charset == "US-ASCII")
        #expect(word.encoding == .q)
        #expect(try word.octets == [Byte](utf8: "Keith Moore"))
    }

    @Test
    func `a Q encoded word decodes a hexadecimal octet`() throws {
        let word = try RFC_2047.EncodedWord("=?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?=")

        #expect(word.charset == "ISO-8859-1")
        #expect(try word.octets == [Byte](utf8: "Keld J") + [Byte(bitPattern: 0xF8)] + [Byte](utf8: "rn Simonsen"))
    }

    @Test
    func `a B encoded word decodes base64`() throws {
        let word = try RFC_2047.EncodedWord("=?ISO-8859-1?B?SWYgeW91IGNhbiByZWFkIHRoaXMgeW8=?=")

        #expect(word.encoding == .b)
        #expect(try word.octets == [Byte](utf8: "If you can read this yo"))
    }

    @Test
    func `the encoding letter is case insensitive`() throws {
        #expect(try RFC_2047.EncodedWord("=?utf-8?q?a?=").encoding == .q)
        #expect(try RFC_2047.EncodedWord("=?utf-8?b?YQ==?=").encoding == .b)
    }

    @Test
    func `a lowercase hexadecimal octet decodes`() throws {
        #expect(try RFC_2047.EncodedWord("=?ISO-8859-1?Q?=e9?=").octets == [Byte(bitPattern: 0xE9)])
    }
}

extension RFC_2047.EncodedWord.Test.`Edge Case` {

    @Test
    func `a word without its delimiters is refused`() {
        #expect(throws: RFC_2047.EncodedWord.Error.missingDelimiters) {
            try RFC_2047.EncodedWord("?US-ASCII?Q?a?=")
        }
        #expect(throws: RFC_2047.EncodedWord.Error.missingDelimiters) {
            try RFC_2047.EncodedWord("=?US-ASCII?Q?a?")
        }
    }

    @Test
    func `a word with too many fields is refused`() {
        #expect(throws: RFC_2047.EncodedWord.Error.malformedStructure) {
            try RFC_2047.EncodedWord("=?US-ASCII?Q?a?b?=")
        }
    }

    @Test
    func `an unknown encoding is refused`() {
        #expect(throws: RFC_2047.EncodedWord.Error.unknownEncoding) {
            try RFC_2047.EncodedWord("=?US-ASCII?X?a?=")
        }
        #expect(throws: RFC_2047.EncodedWord.Error.unknownEncoding) {
            try RFC_2047.EncodedWord("=?US-ASCII?QQ?a?=")
        }
    }

    @Test
    func `a charset with an especial is refused`() {
        #expect(throws: RFC_2047.EncodedWord.Error.invalidCharset) {
            try RFC_2047.EncodedWord("=?ISO.8859?Q?a?=")
        }
        #expect(throws: RFC_2047.EncodedWord.Error.invalidCharset) {
            try RFC_2047.EncodedWord("=??Q?a?=")
        }
    }

    @Test
    func `empty encoded text is refused`() {
        #expect(throws: RFC_2047.EncodedWord.Error.invalidText) {
            try RFC_2047.EncodedWord("=?US-ASCII?Q??=")
        }
    }

    @Test
    func `a non ASCII byte is refused`() {
        #expect(throws: RFC_2047.EncodedWord.Error.notASCII) {
            try RFC_2047.EncodedWord("=?UTF-8?Q?é?=")
        }
    }

    @Test
    func `a broken quoted octet fails to decode`() throws {
        let truncated = try RFC_2047.EncodedWord("=?US-ASCII?Q?a=4?=")
        let invalid = try RFC_2047.EncodedWord("=?US-ASCII?Q?a=ZZ?=")

        #expect(throws: RFC_2047.EncodedWord.Error.invalidQuotedOctet) { try truncated.octets }
        #expect(throws: RFC_2047.EncodedWord.Error.invalidQuotedOctet) { try invalid.octets }
    }

    @Test
    func `invalid base64 fails to decode`() throws {
        let word = try RFC_2047.EncodedWord("=?US-ASCII?B?a*b*?=")

        #expect(throws: RFC_2047.EncodedWord.Error.invalidBase64) { try word.octets }
    }
}
