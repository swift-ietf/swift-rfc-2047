# swift-rfc-2047

Use this package when you read a mail header that may contain encoded words such as `=?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?=`. Start from `RFC_2047.Text` for a whole header value and `RFC_2047.EncodedWord` for a single word. The package decodes to octets and names their charset. It does not convert them to a Swift string and does not encode. For encoded parameter values such as non-ASCII filenames, use swift-rfc-2231.

## Laws

- An encoded word is checked for its structure when it is read: delimiters, a charset token without especials, a one-letter encoding of B or Q in either case, and non-empty printable text with no `?` or space. The encoded text itself is decoded only when you read `RFC_2047.EncodedWord.octets`, so broken Base64 or a broken quoted octet fails there and not before.
- In Q encoding `_` decodes to a space, and `=` must be followed by two hexadecimal digits in either case.
- `RFC_2047.Text` splits the input at runs of space, tab, CR and LF. A run that is a valid encoded word becomes a word. Anything else, including a malformed encoded word or one glued to other text, stays text with its bytes unchanged.
- Whitespace between two encoded words is dropped, including a folded line break. All other whitespace, including at the start and end, is kept.
- Neighbouring text pieces are merged, so plain text is a single segment. Each encoded word keeps its own charset, even next to a word in another charset.
