extension RFC_2047 {

    public struct Text: Sendable, Hashable {

        public let segments: [RFC_2047.Text.Segment]

        public init(segments: [RFC_2047.Text.Segment]) {
            self.segments = segments
        }
    }
}
