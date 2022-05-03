// Nil coalescing operator that throws an error.
infix operator ???

public func ???<T>(optional: T?, error: @autoclosure () -> Error) throws -> T {
    guard let value = optional else {
        throw error()
    }
    return value
}
