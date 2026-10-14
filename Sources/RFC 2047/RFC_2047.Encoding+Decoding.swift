public import ASCII
public import Byte
import RFC_4648

extension RFC_2047.Encoding {

    public func decode(_ text: [ASCII.Code]) throws(RFC_2047.EncodedWord.Error) -> [Byte] {
        switch self {
        case .b:
            guard let octets = RFC_4648.Base64.decode(text) else {
                throw .invalidBase64
            }
            return octets
        case .q:
            return try Self.quoted(text)
        }
    }

    private static func quoted(_ text: [ASCII.Code]) throws(RFC_2047.EncodedWord.Error) -> [Byte] {
        var octets: [Byte] = []
        octets.reserveCapacity(text.count)
        var position = text.startIndex
        while position < text.endIndex {
            let code = text[position]
            switch code {
            case .underscore:
                octets.append(ASCII.Code.space.byte)
                position += 1
            case .equalsSign:
                guard position + 2 < text.endIndex,
                    let octet = RFC_4648.Base16.decode(high: text[position + 1], low: text[position + 2])
                else {
                    throw .invalidQuotedOctet
                }
                octets.append(Byte(bitPattern: octet))
                position += 3
            default:
                octets.append(code.byte)
                position += 1
            }
        }
        return octets
    }
}
