import ASCII
public import Byte
import RFC_2045

extension RFC_2047.EncodedWord {

    public init(_ string: some StringProtocol) throws(Error) {
        try self.init(ascii: string.utf8.map(Byte.init(bitPattern:)))
    }

    public init<Bytes: Swift.Collection>(ascii bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        let codes: [ASCII.Code]
        do throws(ASCII.Code.Error) {
            codes = try bytes.map { (byte: Byte) throws(ASCII.Code.Error) -> ASCII.Code in try ASCII.Code(byte) }
        } catch {
            throw .notASCII
        }
        guard codes.count >= 4,
            codes[0] == .equalsSign, codes[1] == .questionMark,
            codes[codes.count - 2] == .questionMark, codes[codes.count - 1] == .equalsSign
        else {
            throw .missingDelimiters
        }
        let fields = codes[2..<(codes.count - 2)].split(separator: .questionMark, omittingEmptySubsequences: false)
        guard fields.count == 3 else {
            throw .malformedStructure
        }
        let charset = Array(fields[0])
        guard !charset.isEmpty, charset.allSatisfy(Self.isToken) else {
            throw .invalidCharset
        }
        guard fields[1].count == 1, let encoding = RFC_2047.Encoding(fields[1][fields[1].startIndex]) else {
            throw .unknownEncoding
        }
        let text = Array(fields[2])
        guard !text.isEmpty, text.allSatisfy({ $0.isVisible && $0 != .questionMark }) else {
            throw .invalidText
        }
        let name: RFC_2045.Charset
        do throws(RFC_2045.Charset.Error) {
            name = try RFC_2045.Charset(ascii: charset.map(\.byte))
        } catch {
            throw .invalidCharset
        }
        self.init(charset: name, encoding: encoding, text: text)
    }

    private static func isToken(_ code: ASCII.Code) -> Bool {
        code.isVisible && !especials.contains(code.underlying)
    }

    private static let especials: Set<UInt8> = [
        0x28, 0x29, 0x3C, 0x3E, 0x40, 0x2C, 0x3B, 0x3A, 0x22, 0x2F, 0x5B, 0x5D, 0x3F, 0x2E, 0x3D, 0x5C,
    ]
}
