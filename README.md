# swift-rfc-2047

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Foundation-free Swift implementation of RFC 2047: MIME message header extensions for non-ASCII text.

The package parses encoded words (`=?charset?B|Q?text?=`), decodes their B and Q encodings to octets, and splits unstructured header text into plain text and encoded words, ignoring the white space between adjacent encoded words as section 6.2 requires. Turning octets in a charset into text is outside this specification package.

```swift
import RFC_2047

let word = try RFC_2047.EncodedWord("=?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?=")
word.charset      // ISO-8859-1
try word.octets   // the decoded octets
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
