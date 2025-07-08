#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 13)

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 15)
    extension ExpressionProxy where T == Float {
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func ceiling() -> ExpressionProxy<Float> {
                .init(
                    expression: .functionCall(
                        functionName: "ceiling",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func exp() -> ExpressionProxy<Float> {
                .init(
                    expression: .functionCall(
                        functionName: "exp",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func floor() -> ExpressionProxy<Float> {
                .init(
                    expression: .functionCall(
                        functionName: "floor",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func ln() -> ExpressionProxy<Float> {
                .init(
                    expression: .functionCall(
                        functionName: "ln",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func log() -> ExpressionProxy<Float> {
                .init(
                    expression: .functionCall(
                        functionName: "log",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func log2() -> ExpressionProxy<Float> {
                .init(
                    expression: .functionCall(
                        functionName: "log2",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func sqrt() -> ExpressionProxy<Float> {
                .init(
                    expression: .functionCall(
                        functionName: "sqrt",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func trunc() -> ExpressionProxy<Float> {
                .init(
                    expression: .functionCall(
                        functionName: "trunc",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 26)
    }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 15)
    extension ExpressionProxy where T == Double {
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func ceiling() -> ExpressionProxy<Double> {
                .init(
                    expression: .functionCall(
                        functionName: "ceiling",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func exp() -> ExpressionProxy<Double> {
                .init(
                    expression: .functionCall(
                        functionName: "exp",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func floor() -> ExpressionProxy<Double> {
                .init(
                    expression: .functionCall(
                        functionName: "floor",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func ln() -> ExpressionProxy<Double> {
                .init(
                    expression: .functionCall(
                        functionName: "ln",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func log() -> ExpressionProxy<Double> {
                .init(
                    expression: .functionCall(
                        functionName: "log",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func log2() -> ExpressionProxy<Double> {
                .init(
                    expression: .functionCall(
                        functionName: "log2",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func sqrt() -> ExpressionProxy<Double> {
                .init(
                    expression: .functionCall(
                        functionName: "sqrt",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 17)
            public func trunc() -> ExpressionProxy<Double> {
                .init(
                    expression: .functionCall(
                        functionName: "trunc",
                        arguments: [self.expression]
                    )
                )
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 26)
    }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 28)

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 30)
    extension ExpressionProxy where T == Int16 {
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func << (
                    lhs: ExpressionProxy<Int16>,
                    rhs: ExpressionProxy<Int16>
                ) -> ExpressionProxy<Int16> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "leftshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: "<<",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func << (
                    lhs: ExpressionProxy<Int16>,
                    rhs: Int16
                ) -> ExpressionProxy<Int16> {
                    lhs << ExpressionProxy<Int16>(rhs)
                }
                public static func << (
                    lhs: Int16,
                    rhs: ExpressionProxy<Int16>
                ) -> ExpressionProxy<Int16> {
                    ExpressionProxy(lhs) << rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func >> (
                    lhs: ExpressionProxy<Int16>,
                    rhs: ExpressionProxy<Int16>
                ) -> ExpressionProxy<Int16> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "rightshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: ">>",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func >> (
                    lhs: ExpressionProxy<Int16>,
                    rhs: Int16
                ) -> ExpressionProxy<Int16> {
                    lhs >> ExpressionProxy<Int16>(rhs)
                }
                public static func >> (
                    lhs: Int16,
                    rhs: ExpressionProxy<Int16>
                ) -> ExpressionProxy<Int16> {
                    ExpressionProxy(lhs) >> rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func << (
                    lhs: ExpressionProxy<Int16>,
                    rhs: ExpressionProxy<Int32>
                ) -> ExpressionProxy<Int16> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "leftshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: "<<",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func << (
                    lhs: ExpressionProxy<Int16>,
                    rhs: Int32
                ) -> ExpressionProxy<Int16> {
                    lhs << ExpressionProxy<Int32>(rhs)
                }
                public static func << (
                    lhs: Int16,
                    rhs: ExpressionProxy<Int32>
                ) -> ExpressionProxy<Int16> {
                    ExpressionProxy(lhs) << rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func >> (
                    lhs: ExpressionProxy<Int16>,
                    rhs: ExpressionProxy<Int32>
                ) -> ExpressionProxy<Int16> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "rightshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: ">>",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func >> (
                    lhs: ExpressionProxy<Int16>,
                    rhs: Int32
                ) -> ExpressionProxy<Int16> {
                    lhs >> ExpressionProxy<Int32>(rhs)
                }
                public static func >> (
                    lhs: Int16,
                    rhs: ExpressionProxy<Int32>
                ) -> ExpressionProxy<Int16> {
                    ExpressionProxy(lhs) >> rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func << (
                    lhs: ExpressionProxy<Int16>,
                    rhs: ExpressionProxy<Int64>
                ) -> ExpressionProxy<Int16> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "leftshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: "<<",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func << (
                    lhs: ExpressionProxy<Int16>,
                    rhs: Int64
                ) -> ExpressionProxy<Int16> {
                    lhs << ExpressionProxy<Int64>(rhs)
                }
                public static func << (
                    lhs: Int16,
                    rhs: ExpressionProxy<Int64>
                ) -> ExpressionProxy<Int16> {
                    ExpressionProxy(lhs) << rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func >> (
                    lhs: ExpressionProxy<Int16>,
                    rhs: ExpressionProxy<Int64>
                ) -> ExpressionProxy<Int16> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "rightshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: ">>",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func >> (
                    lhs: ExpressionProxy<Int16>,
                    rhs: Int64
                ) -> ExpressionProxy<Int16> {
                    lhs >> ExpressionProxy<Int64>(rhs)
                }
                public static func >> (
                    lhs: Int16,
                    rhs: ExpressionProxy<Int64>
                ) -> ExpressionProxy<Int16> {
                    ExpressionProxy(lhs) >> rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 68)

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 70)
            public static func % (
                lhs: ExpressionProxy<Int16>,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                #if canImport(CoreData)
                    .init(
                        expression: .functionCall(
                            functionName: "modulus:by:",
                            arguments: [lhs.expression, rhs.expression]
                        )
                    )
                #else
                    .init(
                        expression: .binaryOperator(
                            operation: "%",
                            lhs: lhs.expression,
                            rhs: rhs.expression
                        )
                    )
                #endif
            }
            public static func % (
                lhs: ExpressionProxy<Int16>,
                rhs: Int16
            ) -> ExpressionProxy<Int16> {
                lhs % ExpressionProxy(rhs)
            }
            public static func % (
                lhs: Int16,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                ExpressionProxy(lhs) % rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 70)
            public static func & (
                lhs: ExpressionProxy<Int16>,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                #if canImport(CoreData)
                    .init(
                        expression: .functionCall(
                            functionName: "bitwiseAnd:with:",
                            arguments: [lhs.expression, rhs.expression]
                        )
                    )
                #else
                    .init(
                        expression: .binaryOperator(
                            operation: "&",
                            lhs: lhs.expression,
                            rhs: rhs.expression
                        )
                    )
                #endif
            }
            public static func & (
                lhs: ExpressionProxy<Int16>,
                rhs: Int16
            ) -> ExpressionProxy<Int16> {
                lhs & ExpressionProxy(rhs)
            }
            public static func & (
                lhs: Int16,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                ExpressionProxy(lhs) & rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 70)
            public static func | (
                lhs: ExpressionProxy<Int16>,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                #if canImport(CoreData)
                    .init(
                        expression: .functionCall(
                            functionName: "bitwiseOr:with:",
                            arguments: [lhs.expression, rhs.expression]
                        )
                    )
                #else
                    .init(
                        expression: .binaryOperator(
                            operation: "|",
                            lhs: lhs.expression,
                            rhs: rhs.expression
                        )
                    )
                #endif
            }
            public static func | (
                lhs: ExpressionProxy<Int16>,
                rhs: Int16
            ) -> ExpressionProxy<Int16> {
                lhs | ExpressionProxy(rhs)
            }
            public static func | (
                lhs: Int16,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                ExpressionProxy(lhs) | rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 104)
    }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 30)
    extension ExpressionProxy where T == Int32 {
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func << (
                    lhs: ExpressionProxy<Int32>,
                    rhs: ExpressionProxy<Int16>
                ) -> ExpressionProxy<Int32> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "leftshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: "<<",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func << (
                    lhs: ExpressionProxy<Int32>,
                    rhs: Int16
                ) -> ExpressionProxy<Int32> {
                    lhs << ExpressionProxy<Int16>(rhs)
                }
                public static func << (
                    lhs: Int32,
                    rhs: ExpressionProxy<Int16>
                ) -> ExpressionProxy<Int32> {
                    ExpressionProxy(lhs) << rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func >> (
                    lhs: ExpressionProxy<Int32>,
                    rhs: ExpressionProxy<Int16>
                ) -> ExpressionProxy<Int32> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "rightshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: ">>",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func >> (
                    lhs: ExpressionProxy<Int32>,
                    rhs: Int16
                ) -> ExpressionProxy<Int32> {
                    lhs >> ExpressionProxy<Int16>(rhs)
                }
                public static func >> (
                    lhs: Int32,
                    rhs: ExpressionProxy<Int16>
                ) -> ExpressionProxy<Int32> {
                    ExpressionProxy(lhs) >> rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func << (
                    lhs: ExpressionProxy<Int32>,
                    rhs: ExpressionProxy<Int32>
                ) -> ExpressionProxy<Int32> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "leftshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: "<<",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func << (
                    lhs: ExpressionProxy<Int32>,
                    rhs: Int32
                ) -> ExpressionProxy<Int32> {
                    lhs << ExpressionProxy<Int32>(rhs)
                }
                public static func << (
                    lhs: Int32,
                    rhs: ExpressionProxy<Int32>
                ) -> ExpressionProxy<Int32> {
                    ExpressionProxy(lhs) << rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func >> (
                    lhs: ExpressionProxy<Int32>,
                    rhs: ExpressionProxy<Int32>
                ) -> ExpressionProxy<Int32> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "rightshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: ">>",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func >> (
                    lhs: ExpressionProxy<Int32>,
                    rhs: Int32
                ) -> ExpressionProxy<Int32> {
                    lhs >> ExpressionProxy<Int32>(rhs)
                }
                public static func >> (
                    lhs: Int32,
                    rhs: ExpressionProxy<Int32>
                ) -> ExpressionProxy<Int32> {
                    ExpressionProxy(lhs) >> rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func << (
                    lhs: ExpressionProxy<Int32>,
                    rhs: ExpressionProxy<Int64>
                ) -> ExpressionProxy<Int32> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "leftshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: "<<",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func << (
                    lhs: ExpressionProxy<Int32>,
                    rhs: Int64
                ) -> ExpressionProxy<Int32> {
                    lhs << ExpressionProxy<Int64>(rhs)
                }
                public static func << (
                    lhs: Int32,
                    rhs: ExpressionProxy<Int64>
                ) -> ExpressionProxy<Int32> {
                    ExpressionProxy(lhs) << rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func >> (
                    lhs: ExpressionProxy<Int32>,
                    rhs: ExpressionProxy<Int64>
                ) -> ExpressionProxy<Int32> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "rightshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: ">>",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func >> (
                    lhs: ExpressionProxy<Int32>,
                    rhs: Int64
                ) -> ExpressionProxy<Int32> {
                    lhs >> ExpressionProxy<Int64>(rhs)
                }
                public static func >> (
                    lhs: Int32,
                    rhs: ExpressionProxy<Int64>
                ) -> ExpressionProxy<Int32> {
                    ExpressionProxy(lhs) >> rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 68)

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 70)
            public static func % (
                lhs: ExpressionProxy<Int32>,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                #if canImport(CoreData)
                    .init(
                        expression: .functionCall(
                            functionName: "modulus:by:",
                            arguments: [lhs.expression, rhs.expression]
                        )
                    )
                #else
                    .init(
                        expression: .binaryOperator(
                            operation: "%",
                            lhs: lhs.expression,
                            rhs: rhs.expression
                        )
                    )
                #endif
            }
            public static func % (
                lhs: ExpressionProxy<Int32>,
                rhs: Int32
            ) -> ExpressionProxy<Int32> {
                lhs % ExpressionProxy(rhs)
            }
            public static func % (
                lhs: Int32,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                ExpressionProxy(lhs) % rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 70)
            public static func & (
                lhs: ExpressionProxy<Int32>,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                #if canImport(CoreData)
                    .init(
                        expression: .functionCall(
                            functionName: "bitwiseAnd:with:",
                            arguments: [lhs.expression, rhs.expression]
                        )
                    )
                #else
                    .init(
                        expression: .binaryOperator(
                            operation: "&",
                            lhs: lhs.expression,
                            rhs: rhs.expression
                        )
                    )
                #endif
            }
            public static func & (
                lhs: ExpressionProxy<Int32>,
                rhs: Int32
            ) -> ExpressionProxy<Int32> {
                lhs & ExpressionProxy(rhs)
            }
            public static func & (
                lhs: Int32,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                ExpressionProxy(lhs) & rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 70)
            public static func | (
                lhs: ExpressionProxy<Int32>,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                #if canImport(CoreData)
                    .init(
                        expression: .functionCall(
                            functionName: "bitwiseOr:with:",
                            arguments: [lhs.expression, rhs.expression]
                        )
                    )
                #else
                    .init(
                        expression: .binaryOperator(
                            operation: "|",
                            lhs: lhs.expression,
                            rhs: rhs.expression
                        )
                    )
                #endif
            }
            public static func | (
                lhs: ExpressionProxy<Int32>,
                rhs: Int32
            ) -> ExpressionProxy<Int32> {
                lhs | ExpressionProxy(rhs)
            }
            public static func | (
                lhs: Int32,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                ExpressionProxy(lhs) | rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 104)
    }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 30)
    extension ExpressionProxy where T == Int64 {
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func << (
                    lhs: ExpressionProxy<Int64>,
                    rhs: ExpressionProxy<Int16>
                ) -> ExpressionProxy<Int64> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "leftshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: "<<",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func << (
                    lhs: ExpressionProxy<Int64>,
                    rhs: Int16
                ) -> ExpressionProxy<Int64> {
                    lhs << ExpressionProxy<Int16>(rhs)
                }
                public static func << (
                    lhs: Int64,
                    rhs: ExpressionProxy<Int16>
                ) -> ExpressionProxy<Int64> {
                    ExpressionProxy(lhs) << rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func >> (
                    lhs: ExpressionProxy<Int64>,
                    rhs: ExpressionProxy<Int16>
                ) -> ExpressionProxy<Int64> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "rightshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: ">>",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func >> (
                    lhs: ExpressionProxy<Int64>,
                    rhs: Int16
                ) -> ExpressionProxy<Int64> {
                    lhs >> ExpressionProxy<Int16>(rhs)
                }
                public static func >> (
                    lhs: Int64,
                    rhs: ExpressionProxy<Int16>
                ) -> ExpressionProxy<Int64> {
                    ExpressionProxy(lhs) >> rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func << (
                    lhs: ExpressionProxy<Int64>,
                    rhs: ExpressionProxy<Int32>
                ) -> ExpressionProxy<Int64> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "leftshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: "<<",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func << (
                    lhs: ExpressionProxy<Int64>,
                    rhs: Int32
                ) -> ExpressionProxy<Int64> {
                    lhs << ExpressionProxy<Int32>(rhs)
                }
                public static func << (
                    lhs: Int64,
                    rhs: ExpressionProxy<Int32>
                ) -> ExpressionProxy<Int64> {
                    ExpressionProxy(lhs) << rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func >> (
                    lhs: ExpressionProxy<Int64>,
                    rhs: ExpressionProxy<Int32>
                ) -> ExpressionProxy<Int64> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "rightshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: ">>",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func >> (
                    lhs: ExpressionProxy<Int64>,
                    rhs: Int32
                ) -> ExpressionProxy<Int64> {
                    lhs >> ExpressionProxy<Int32>(rhs)
                }
                public static func >> (
                    lhs: Int64,
                    rhs: ExpressionProxy<Int32>
                ) -> ExpressionProxy<Int64> {
                    ExpressionProxy(lhs) >> rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func << (
                    lhs: ExpressionProxy<Int64>,
                    rhs: ExpressionProxy<Int64>
                ) -> ExpressionProxy<Int64> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "leftshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: "<<",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func << (
                    lhs: ExpressionProxy<Int64>,
                    rhs: Int64
                ) -> ExpressionProxy<Int64> {
                    lhs << ExpressionProxy<Int64>(rhs)
                }
                public static func << (
                    lhs: Int64,
                    rhs: ExpressionProxy<Int64>
                ) -> ExpressionProxy<Int64> {
                    ExpressionProxy(lhs) << rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 33)
                public static func >> (
                    lhs: ExpressionProxy<Int64>,
                    rhs: ExpressionProxy<Int64>
                ) -> ExpressionProxy<Int64> {
                    #if canImport(CoreData)
                        .init(
                            expression: .functionCall(
                                functionName: "rightshift:by:",
                                arguments: [lhs.expression, rhs.expression]
                            )
                        )
                    #else
                        .init(
                            expression: .binaryOperator(
                                operation: ">>",
                                lhs: lhs.expression,
                                rhs: rhs.expression
                            )
                        )
                    #endif
                }
                public static func >> (
                    lhs: ExpressionProxy<Int64>,
                    rhs: Int64
                ) -> ExpressionProxy<Int64> {
                    lhs >> ExpressionProxy<Int64>(rhs)
                }
                public static func >> (
                    lhs: Int64,
                    rhs: ExpressionProxy<Int64>
                ) -> ExpressionProxy<Int64> {
                    ExpressionProxy(lhs) >> rhs
                }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 68)

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 70)
            public static func % (
                lhs: ExpressionProxy<Int64>,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                #if canImport(CoreData)
                    .init(
                        expression: .functionCall(
                            functionName: "modulus:by:",
                            arguments: [lhs.expression, rhs.expression]
                        )
                    )
                #else
                    .init(
                        expression: .binaryOperator(
                            operation: "%",
                            lhs: lhs.expression,
                            rhs: rhs.expression
                        )
                    )
                #endif
            }
            public static func % (
                lhs: ExpressionProxy<Int64>,
                rhs: Int64
            ) -> ExpressionProxy<Int64> {
                lhs % ExpressionProxy(rhs)
            }
            public static func % (
                lhs: Int64,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                ExpressionProxy(lhs) % rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 70)
            public static func & (
                lhs: ExpressionProxy<Int64>,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                #if canImport(CoreData)
                    .init(
                        expression: .functionCall(
                            functionName: "bitwiseAnd:with:",
                            arguments: [lhs.expression, rhs.expression]
                        )
                    )
                #else
                    .init(
                        expression: .binaryOperator(
                            operation: "&",
                            lhs: lhs.expression,
                            rhs: rhs.expression
                        )
                    )
                #endif
            }
            public static func & (
                lhs: ExpressionProxy<Int64>,
                rhs: Int64
            ) -> ExpressionProxy<Int64> {
                lhs & ExpressionProxy(rhs)
            }
            public static func & (
                lhs: Int64,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                ExpressionProxy(lhs) & rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 70)
            public static func | (
                lhs: ExpressionProxy<Int64>,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                #if canImport(CoreData)
                    .init(
                        expression: .functionCall(
                            functionName: "bitwiseOr:with:",
                            arguments: [lhs.expression, rhs.expression]
                        )
                    )
                #else
                    .init(
                        expression: .binaryOperator(
                            operation: "|",
                            lhs: lhs.expression,
                            rhs: rhs.expression
                        )
                    )
                #endif
            }
            public static func | (
                lhs: ExpressionProxy<Int64>,
                rhs: Int64
            ) -> ExpressionProxy<Int64> {
                lhs | ExpressionProxy(rhs)
            }
            public static func | (
                lhs: Int64,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                ExpressionProxy(lhs) | rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 104)
    }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 106)

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 108)
    extension ExpressionProxy where T == Int16 {
        public func abs() -> ExpressionProxy<Int16> {
            .init(expression: .functionCall(functionName: "abs", arguments: [self.expression]))
        }

        public static prefix func - (
            operand: ExpressionProxy<Int16>
        ) -> ExpressionProxy<Int16> {
            .init(expression: .unaryOperator(operation: "-", expression: operand.expression))
        }

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func * (
                lhs: ExpressionProxy<Int16>,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                .init(
                    expression: .binaryOperator(
                        operation: "*",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func * (
                lhs: ExpressionProxy<Int16>,
                rhs: Int16
            ) -> ExpressionProxy<Int16> {
                lhs * ExpressionProxy(rhs)
            }
            public static func * (
                lhs: Int16,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                ExpressionProxy(lhs) * rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func / (
                lhs: ExpressionProxy<Int16>,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                .init(
                    expression: .binaryOperator(
                        operation: "/",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func / (
                lhs: ExpressionProxy<Int16>,
                rhs: Int16
            ) -> ExpressionProxy<Int16> {
                lhs / ExpressionProxy(rhs)
            }
            public static func / (
                lhs: Int16,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                ExpressionProxy(lhs) / rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func + (
                lhs: ExpressionProxy<Int16>,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                .init(
                    expression: .binaryOperator(
                        operation: "+",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func + (
                lhs: ExpressionProxy<Int16>,
                rhs: Int16
            ) -> ExpressionProxy<Int16> {
                lhs + ExpressionProxy(rhs)
            }
            public static func + (
                lhs: Int16,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                ExpressionProxy(lhs) + rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func - (
                lhs: ExpressionProxy<Int16>,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                .init(
                    expression: .binaryOperator(
                        operation: "-",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func - (
                lhs: ExpressionProxy<Int16>,
                rhs: Int16
            ) -> ExpressionProxy<Int16> {
                lhs - ExpressionProxy(rhs)
            }
            public static func - (
                lhs: Int16,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Int16> {
                ExpressionProxy(lhs) - rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 145)

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func < (
                lhs: ExpressionProxy<Int16>,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: "<",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func < (
                lhs: ExpressionProxy<Int16>,
                rhs: Int16
            ) -> ExpressionProxy<Bool> {
                lhs < ExpressionProxy(rhs)
            }
            public static func < (
                lhs: Int16,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) < rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func > (
                lhs: ExpressionProxy<Int16>,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: ">",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func > (
                lhs: ExpressionProxy<Int16>,
                rhs: Int16
            ) -> ExpressionProxy<Bool> {
                lhs > ExpressionProxy(rhs)
            }
            public static func > (
                lhs: Int16,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) > rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func <= (
                lhs: ExpressionProxy<Int16>,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: "<=",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func <= (
                lhs: ExpressionProxy<Int16>,
                rhs: Int16
            ) -> ExpressionProxy<Bool> {
                lhs <= ExpressionProxy(rhs)
            }
            public static func <= (
                lhs: Int16,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) <= rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func >= (
                lhs: ExpressionProxy<Int16>,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: ">=",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func >= (
                lhs: ExpressionProxy<Int16>,
                rhs: Int16
            ) -> ExpressionProxy<Bool> {
                lhs >= ExpressionProxy(rhs)
            }
            public static func >= (
                lhs: Int16,
                rhs: ExpressionProxy<Int16>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) >= rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 172)
    }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 108)
    extension ExpressionProxy where T == Int32 {
        public func abs() -> ExpressionProxy<Int32> {
            .init(expression: .functionCall(functionName: "abs", arguments: [self.expression]))
        }

        public static prefix func - (
            operand: ExpressionProxy<Int32>
        ) -> ExpressionProxy<Int32> {
            .init(expression: .unaryOperator(operation: "-", expression: operand.expression))
        }

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func * (
                lhs: ExpressionProxy<Int32>,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                .init(
                    expression: .binaryOperator(
                        operation: "*",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func * (
                lhs: ExpressionProxy<Int32>,
                rhs: Int32
            ) -> ExpressionProxy<Int32> {
                lhs * ExpressionProxy(rhs)
            }
            public static func * (
                lhs: Int32,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                ExpressionProxy(lhs) * rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func / (
                lhs: ExpressionProxy<Int32>,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                .init(
                    expression: .binaryOperator(
                        operation: "/",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func / (
                lhs: ExpressionProxy<Int32>,
                rhs: Int32
            ) -> ExpressionProxy<Int32> {
                lhs / ExpressionProxy(rhs)
            }
            public static func / (
                lhs: Int32,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                ExpressionProxy(lhs) / rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func + (
                lhs: ExpressionProxy<Int32>,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                .init(
                    expression: .binaryOperator(
                        operation: "+",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func + (
                lhs: ExpressionProxy<Int32>,
                rhs: Int32
            ) -> ExpressionProxy<Int32> {
                lhs + ExpressionProxy(rhs)
            }
            public static func + (
                lhs: Int32,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                ExpressionProxy(lhs) + rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func - (
                lhs: ExpressionProxy<Int32>,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                .init(
                    expression: .binaryOperator(
                        operation: "-",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func - (
                lhs: ExpressionProxy<Int32>,
                rhs: Int32
            ) -> ExpressionProxy<Int32> {
                lhs - ExpressionProxy(rhs)
            }
            public static func - (
                lhs: Int32,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Int32> {
                ExpressionProxy(lhs) - rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 145)

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func < (
                lhs: ExpressionProxy<Int32>,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: "<",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func < (
                lhs: ExpressionProxy<Int32>,
                rhs: Int32
            ) -> ExpressionProxy<Bool> {
                lhs < ExpressionProxy(rhs)
            }
            public static func < (
                lhs: Int32,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) < rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func > (
                lhs: ExpressionProxy<Int32>,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: ">",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func > (
                lhs: ExpressionProxy<Int32>,
                rhs: Int32
            ) -> ExpressionProxy<Bool> {
                lhs > ExpressionProxy(rhs)
            }
            public static func > (
                lhs: Int32,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) > rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func <= (
                lhs: ExpressionProxy<Int32>,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: "<=",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func <= (
                lhs: ExpressionProxy<Int32>,
                rhs: Int32
            ) -> ExpressionProxy<Bool> {
                lhs <= ExpressionProxy(rhs)
            }
            public static func <= (
                lhs: Int32,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) <= rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func >= (
                lhs: ExpressionProxy<Int32>,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: ">=",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func >= (
                lhs: ExpressionProxy<Int32>,
                rhs: Int32
            ) -> ExpressionProxy<Bool> {
                lhs >= ExpressionProxy(rhs)
            }
            public static func >= (
                lhs: Int32,
                rhs: ExpressionProxy<Int32>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) >= rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 172)
    }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 108)
    extension ExpressionProxy where T == Int64 {
        public func abs() -> ExpressionProxy<Int64> {
            .init(expression: .functionCall(functionName: "abs", arguments: [self.expression]))
        }

        public static prefix func - (
            operand: ExpressionProxy<Int64>
        ) -> ExpressionProxy<Int64> {
            .init(expression: .unaryOperator(operation: "-", expression: operand.expression))
        }

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func * (
                lhs: ExpressionProxy<Int64>,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                .init(
                    expression: .binaryOperator(
                        operation: "*",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func * (
                lhs: ExpressionProxy<Int64>,
                rhs: Int64
            ) -> ExpressionProxy<Int64> {
                lhs * ExpressionProxy(rhs)
            }
            public static func * (
                lhs: Int64,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                ExpressionProxy(lhs) * rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func / (
                lhs: ExpressionProxy<Int64>,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                .init(
                    expression: .binaryOperator(
                        operation: "/",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func / (
                lhs: ExpressionProxy<Int64>,
                rhs: Int64
            ) -> ExpressionProxy<Int64> {
                lhs / ExpressionProxy(rhs)
            }
            public static func / (
                lhs: Int64,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                ExpressionProxy(lhs) / rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func + (
                lhs: ExpressionProxy<Int64>,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                .init(
                    expression: .binaryOperator(
                        operation: "+",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func + (
                lhs: ExpressionProxy<Int64>,
                rhs: Int64
            ) -> ExpressionProxy<Int64> {
                lhs + ExpressionProxy(rhs)
            }
            public static func + (
                lhs: Int64,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                ExpressionProxy(lhs) + rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func - (
                lhs: ExpressionProxy<Int64>,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                .init(
                    expression: .binaryOperator(
                        operation: "-",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func - (
                lhs: ExpressionProxy<Int64>,
                rhs: Int64
            ) -> ExpressionProxy<Int64> {
                lhs - ExpressionProxy(rhs)
            }
            public static func - (
                lhs: Int64,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Int64> {
                ExpressionProxy(lhs) - rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 145)

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func < (
                lhs: ExpressionProxy<Int64>,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: "<",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func < (
                lhs: ExpressionProxy<Int64>,
                rhs: Int64
            ) -> ExpressionProxy<Bool> {
                lhs < ExpressionProxy(rhs)
            }
            public static func < (
                lhs: Int64,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) < rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func > (
                lhs: ExpressionProxy<Int64>,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: ">",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func > (
                lhs: ExpressionProxy<Int64>,
                rhs: Int64
            ) -> ExpressionProxy<Bool> {
                lhs > ExpressionProxy(rhs)
            }
            public static func > (
                lhs: Int64,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) > rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func <= (
                lhs: ExpressionProxy<Int64>,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: "<=",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func <= (
                lhs: ExpressionProxy<Int64>,
                rhs: Int64
            ) -> ExpressionProxy<Bool> {
                lhs <= ExpressionProxy(rhs)
            }
            public static func <= (
                lhs: Int64,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) <= rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func >= (
                lhs: ExpressionProxy<Int64>,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: ">=",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func >= (
                lhs: ExpressionProxy<Int64>,
                rhs: Int64
            ) -> ExpressionProxy<Bool> {
                lhs >= ExpressionProxy(rhs)
            }
            public static func >= (
                lhs: Int64,
                rhs: ExpressionProxy<Int64>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) >= rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 172)
    }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 108)
    extension ExpressionProxy where T == Float {
        public func abs() -> ExpressionProxy<Float> {
            .init(expression: .functionCall(functionName: "abs", arguments: [self.expression]))
        }

        public static prefix func - (
            operand: ExpressionProxy<Float>
        ) -> ExpressionProxy<Float> {
            .init(expression: .unaryOperator(operation: "-", expression: operand.expression))
        }

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func * (
                lhs: ExpressionProxy<Float>,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Float> {
                .init(
                    expression: .binaryOperator(
                        operation: "*",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func * (
                lhs: ExpressionProxy<Float>,
                rhs: Float
            ) -> ExpressionProxy<Float> {
                lhs * ExpressionProxy(rhs)
            }
            public static func * (
                lhs: Float,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Float> {
                ExpressionProxy(lhs) * rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func / (
                lhs: ExpressionProxy<Float>,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Float> {
                .init(
                    expression: .binaryOperator(
                        operation: "/",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func / (
                lhs: ExpressionProxy<Float>,
                rhs: Float
            ) -> ExpressionProxy<Float> {
                lhs / ExpressionProxy(rhs)
            }
            public static func / (
                lhs: Float,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Float> {
                ExpressionProxy(lhs) / rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func + (
                lhs: ExpressionProxy<Float>,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Float> {
                .init(
                    expression: .binaryOperator(
                        operation: "+",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func + (
                lhs: ExpressionProxy<Float>,
                rhs: Float
            ) -> ExpressionProxy<Float> {
                lhs + ExpressionProxy(rhs)
            }
            public static func + (
                lhs: Float,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Float> {
                ExpressionProxy(lhs) + rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func - (
                lhs: ExpressionProxy<Float>,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Float> {
                .init(
                    expression: .binaryOperator(
                        operation: "-",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func - (
                lhs: ExpressionProxy<Float>,
                rhs: Float
            ) -> ExpressionProxy<Float> {
                lhs - ExpressionProxy(rhs)
            }
            public static func - (
                lhs: Float,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Float> {
                ExpressionProxy(lhs) - rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 145)

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func < (
                lhs: ExpressionProxy<Float>,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: "<",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func < (
                lhs: ExpressionProxy<Float>,
                rhs: Float
            ) -> ExpressionProxy<Bool> {
                lhs < ExpressionProxy(rhs)
            }
            public static func < (
                lhs: Float,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) < rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func > (
                lhs: ExpressionProxy<Float>,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: ">",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func > (
                lhs: ExpressionProxy<Float>,
                rhs: Float
            ) -> ExpressionProxy<Bool> {
                lhs > ExpressionProxy(rhs)
            }
            public static func > (
                lhs: Float,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) > rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func <= (
                lhs: ExpressionProxy<Float>,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: "<=",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func <= (
                lhs: ExpressionProxy<Float>,
                rhs: Float
            ) -> ExpressionProxy<Bool> {
                lhs <= ExpressionProxy(rhs)
            }
            public static func <= (
                lhs: Float,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) <= rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func >= (
                lhs: ExpressionProxy<Float>,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: ">=",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func >= (
                lhs: ExpressionProxy<Float>,
                rhs: Float
            ) -> ExpressionProxy<Bool> {
                lhs >= ExpressionProxy(rhs)
            }
            public static func >= (
                lhs: Float,
                rhs: ExpressionProxy<Float>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) >= rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 172)
    }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 108)
    extension ExpressionProxy where T == Double {
        public func abs() -> ExpressionProxy<Double> {
            .init(expression: .functionCall(functionName: "abs", arguments: [self.expression]))
        }

        public static prefix func - (
            operand: ExpressionProxy<Double>
        ) -> ExpressionProxy<Double> {
            .init(expression: .unaryOperator(operation: "-", expression: operand.expression))
        }

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func * (
                lhs: ExpressionProxy<Double>,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Double> {
                .init(
                    expression: .binaryOperator(
                        operation: "*",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func * (
                lhs: ExpressionProxy<Double>,
                rhs: Double
            ) -> ExpressionProxy<Double> {
                lhs * ExpressionProxy(rhs)
            }
            public static func * (
                lhs: Double,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Double> {
                ExpressionProxy(lhs) * rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func / (
                lhs: ExpressionProxy<Double>,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Double> {
                .init(
                    expression: .binaryOperator(
                        operation: "/",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func / (
                lhs: ExpressionProxy<Double>,
                rhs: Double
            ) -> ExpressionProxy<Double> {
                lhs / ExpressionProxy(rhs)
            }
            public static func / (
                lhs: Double,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Double> {
                ExpressionProxy(lhs) / rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func + (
                lhs: ExpressionProxy<Double>,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Double> {
                .init(
                    expression: .binaryOperator(
                        operation: "+",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func + (
                lhs: ExpressionProxy<Double>,
                rhs: Double
            ) -> ExpressionProxy<Double> {
                lhs + ExpressionProxy(rhs)
            }
            public static func + (
                lhs: Double,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Double> {
                ExpressionProxy(lhs) + rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 120)
            public static func - (
                lhs: ExpressionProxy<Double>,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Double> {
                .init(
                    expression: .binaryOperator(
                        operation: "-",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func - (
                lhs: ExpressionProxy<Double>,
                rhs: Double
            ) -> ExpressionProxy<Double> {
                lhs - ExpressionProxy(rhs)
            }
            public static func - (
                lhs: Double,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Double> {
                ExpressionProxy(lhs) - rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 145)

#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func < (
                lhs: ExpressionProxy<Double>,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: "<",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func < (
                lhs: ExpressionProxy<Double>,
                rhs: Double
            ) -> ExpressionProxy<Bool> {
                lhs < ExpressionProxy(rhs)
            }
            public static func < (
                lhs: Double,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) < rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func > (
                lhs: ExpressionProxy<Double>,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: ">",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func > (
                lhs: ExpressionProxy<Double>,
                rhs: Double
            ) -> ExpressionProxy<Bool> {
                lhs > ExpressionProxy(rhs)
            }
            public static func > (
                lhs: Double,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) > rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func <= (
                lhs: ExpressionProxy<Double>,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: "<=",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func <= (
                lhs: ExpressionProxy<Double>,
                rhs: Double
            ) -> ExpressionProxy<Bool> {
                lhs <= ExpressionProxy(rhs)
            }
            public static func <= (
                lhs: Double,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) <= rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 147)
            public static func >= (
                lhs: ExpressionProxy<Double>,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Bool> {
                .init(
                    expression: .binaryOperator(
                        operation: ">=",
                        lhs: lhs.expression,
                        rhs: rhs.expression
                    )
                )
            }
            public static func >= (
                lhs: ExpressionProxy<Double>,
                rhs: Double
            ) -> ExpressionProxy<Bool> {
                lhs >= ExpressionProxy(rhs)
            }
            public static func >= (
                lhs: Double,
                rhs: ExpressionProxy<Double>
            ) -> ExpressionProxy<Bool> {
                ExpressionProxy(lhs) >= rhs
            }
#sourceLocation(file: "Sources/SwiftCrossData/ProxyExtensions.swift.gyb", line: 172)
    }
