extension IETF.RFC.`2047` {

    public struct Text: Sendable, Hashable {

        public let segments: [IETF.RFC.`2047`.Text.Segment]

        public init(segments: [IETF.RFC.`2047`.Text.Segment]) {
            self.segments = segments
        }
    }
}
