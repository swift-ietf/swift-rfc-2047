public import ASCII

extension RFC_2047.Encoding {

    public init?(_ code: ASCII.Code) {
        switch code.underlying {
        case 0x42, 0x62: self = .b
        case 0x51, 0x71: self = .q
        default: return nil
        }
    }
}
