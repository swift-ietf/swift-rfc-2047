import Byte
import RFC_2045
import RFC_2047
import Testing

extension RFC_2047.Text {

    @Suite
    struct Test {

        @Suite
        struct Unit {}

        @Suite
        struct `Edge Case` {}

        static func displayed(_ header: String) throws -> String {
            let text = RFC_2047.Text([Byte](utf8: header))
            var octets: [Byte] = []
            for segment in text.segments {
                switch segment {
                case .text(let bytes): octets += bytes
                case .word(let word): octets += try word.octets
                }
            }
            return String(decoding: octets.map(\.bitPattern), as: UTF8.self)
        }
    }
}

extension RFC_2047.Text.Test.Unit {

    @Test
    func `text after an encoded word keeps its space`() throws {
        #expect(try RFC_2047.Text.Test.displayed("=?ISO-8859-1?Q?a?= b") == "a b")
    }

    @Test
    func `space between adjacent encoded words is ignored`() throws {
        #expect(try RFC_2047.Text.Test.displayed("=?ISO-8859-1?Q?a?= =?ISO-8859-1?Q?b?=") == "ab")
        #expect(try RFC_2047.Text.Test.displayed("=?ISO-8859-1?Q?a?=  =?ISO-8859-1?Q?b?=") == "ab")
        #expect(try RFC_2047.Text.Test.displayed("=?ISO-8859-1?Q?a?=\r\n =?ISO-8859-1?Q?b?=") == "ab")
    }

    @Test
    func `a space inside an encoded word is kept`() throws {
        #expect(try RFC_2047.Text.Test.displayed("=?ISO-8859-1?Q?a_b?=") == "a b")
        #expect(try RFC_2047.Text.Test.displayed("=?ISO-8859-1?Q?a?= =?ISO-8859-2?Q?_b?=") == "a b")
    }

    @Test
    func `encoded words split across charsets keep their own charset`() {
        let text = RFC_2047.Text([Byte](utf8: "=?ISO-8859-1?Q?a?= =?ISO-8859-2?Q?b?="))
        let charsets = text.segments.compactMap { segment -> String? in
            switch segment {
            case .word(let word): word.charset.rawValue
            case .text: nil
            }
        }

        #expect(charsets == ["ISO-8859-1", "ISO-8859-2"])
    }

    @Test
    func `plain text stays one text segment`() {
        #expect(RFC_2047.Text([Byte](utf8: "Hello  world")).segments == [.text([Byte](utf8: "Hello  world"))])
    }
}

extension RFC_2047.Text.Test.`Edge Case` {

    @Test
    func `an encoded word not delimited by space is text`() throws {
        #expect(try RFC_2047.Text.Test.displayed("x=?US-ASCII?Q?a?=") == "x=?US-ASCII?Q?a?=")
    }

    @Test
    func `a malformed encoded word is text`() throws {
        #expect(try RFC_2047.Text.Test.displayed("=?US-ASCII?X?a?= b") == "=?US-ASCII?X?a?= b")
    }

    @Test
    func `UTF-8 octets in text are kept`() throws {
        #expect(try RFC_2047.Text.Test.displayed("Café =?US-ASCII?Q?ok?=") == "Café ok")
    }

    @Test
    func `leading and trailing space is kept`() throws {
        #expect(try RFC_2047.Text.Test.displayed(" =?US-ASCII?Q?a?= ") == " a ")
    }

    @Test
    func `empty input has no segments`() {
        #expect(RFC_2047.Text([Byte]()).segments.isEmpty)
    }
}
