//
//  AnySubject.swift
//  APIAccess
//
//  Created by Andy Bezaire on 6.3.2021.
//
// Help from: https://github.com/OpenCombine/OpenCombine/blob/master/Sources/OpenCombine/AnyPublisher.swift

import Combine
import Foundation

public extension Subject {
    /// Wraps this subject with a type eraser.
    ///
    /// Use `eraseToAnySubject()` to expose an instance of `AnySubject`` to
    /// the downstream subscriber, rather than this subject’s actual type.
    /// This form of _type erasure_ preserves abstraction across API boundaries, such as
    /// different modules.
    /// When you expose your subjects as the `AnySubject` type, you can change
    /// the underlying implementation over time without affecting existing clients.
    ///
    /// The following example shows two types that each have a `subject` property.
    /// `TypeWithSubject` exposes this property as its actual type, `PassthroughSubject`,
    /// while `TypeWithErasedSubject` uses `eraseToAnySubject()` to expose it as
    /// an `AnySubject`. As seen in the output, a caller from another module can access
    /// `TypeWithSubject.subject` as its native type. This means you can’t change your
    /// subject to a different type without breaking the caller. By comparison,
    /// `TypeWithErasedSubject.subject` appears to callers as an `AnySubject`, so you
    /// can change the underlying subject type at will.
    ///
    ///     public class TypeWithSubject {
    ///         public let subject: some Subject = PassthroughSubject<Int,Never>()
    ///     }
    ///     public class TypeWithErasedSubject {
    ///         public let subject: some Subject = PassthroughSubject<Int,Never>()
    ///             .eraseToAnySubject()
    ///     }
    ///
    ///     // In another module:
    ///     let nonErased = TypeWithSubject()
    ///     if let subject = nonErased.subject as? PassthroughSubject<Int,Never> {
    ///         print("Successfully cast nonErased.subject.")
    ///     }
    ///     let erased = TypeWithErasedSubject()
    ///     if let subject = erased.subject as? PassthroughSubject<Int,Never> {
    ///         print("Successfully cast erased.subject.")
    ///     }
    ///
    ///     // Prints "Successfully cast nonErased.subject."
    ///
    /// - Returns: An ``AnySubject`` wrapping this subject.
    @inlinable
    func eraseToAnySubject() -> AnySubject<Output, Failure> {
        return .init(self)
    }
}

/// A type-erasing subject.
///
/// Use `AnySubject` to wrap a subject whose type has details you don’t want to expose
/// across API boundaries, such as different modules. When you
/// use type erasure this way, you can change the underlying subject implementation over
/// time without affecting existing clients.
///
/// You can use OpenCombine’s `eraseToAnySubject()` operator to wrap a subject with
/// `AnySubject`.
public class AnySubject<Output, Failure: Error> {
    @usableFromInline
    internal let box: SubjectBoxBase<Output, Failure>

    /// Creates a type-erasing subject to wrap the provided subject.
    ///
    /// - Parameter subject: A subject to wrap with a type-eraser.
    @inlinable
    public init<SubjectType: Subject>(_ subject: SubjectType)
        where Output == SubjectType.Output, Failure == SubjectType.Failure
    {
        // If this has already been boxed, avoid boxing again
        if let erased = subject as? AnySubject<Output, Failure> {
            box = erased.box
        } else {
            box = SubjectBox(base: subject)
        }
    }

    public var description: String {
        return "AnySubject"
    }

    public var playgroundDescription: Any {
        return description
    }
}

extension AnySubject: Subject {
    /// This function is called to attach the specified `Subscriber` to this `Subject`
    /// by `subscribe(_:)`
    ///
    /// - SeeAlso: `subscribe(_:)`
    /// - Parameters:
    ///     - subscriber: The subscriber to attach to this `Subject`.
    ///                   once attached it can begin to receive values.
    @inlinable
    public func receive<Downstream: Subscriber>(subscriber: Downstream)
        where Output == Downstream.Input, Failure == Downstream.Failure
    {
        box.receive(subscriber: subscriber)
    }

    @inlinable
    public func send(_ value: Output) {
        box.send(value)
    }

    @inlinable
    public func send(completion: Subscribers.Completion<Failure>) {
        box.send(completion: completion)
    }

    @inlinable
    public func send(subscription: Subscription) {
        box.send(subscription: subscription)
    }
}

/// A type-erasing base class. Its concrete subclass is generic over the underlying
/// publisher.
@usableFromInline
internal class SubjectBoxBase<Output, Failure: Error>: Subject {
    @inlinable
    internal init() {}

    @usableFromInline
    internal func receive<Downstream: Subscriber>(subscriber: Downstream)
        where Failure == Downstream.Failure, Output == Downstream.Input
    {
        abstractMethod()
    }

    @usableFromInline
    internal func send(_ value: Output) {}

    @usableFromInline
    internal func send(completion: Subscribers.Completion<Failure>) {}

    @usableFromInline
    internal func send(subscription: Subscription) {}
}

@usableFromInline
internal final class SubjectBox<SubjectType: Subject>:
    SubjectBoxBase<SubjectType.Output, SubjectType.Failure>
{
    @usableFromInline
    internal let base: SubjectType

    @inlinable
    internal init(base: SubjectType) {
        self.base = base
        super.init()
    }

    @inlinable
    override internal func receive<Downstream: Subscriber>(subscriber: Downstream)
        where Failure == Downstream.Failure, Output == Downstream.Input
    {
        base.receive(subscriber: subscriber)
    }

    @inlinable
    override internal func send(_ value: Output) {
        base.send(value)
    }

    @inlinable
    override internal func send(completion: Subscribers.Completion<Failure>) {
        base.send(completion: completion)
    }

    @inlinable
    override internal func send(subscription: Subscription) {
        base.send(subscription: subscription)
    }
}
