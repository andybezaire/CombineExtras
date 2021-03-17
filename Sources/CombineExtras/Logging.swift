//
//  Logging.swift
//
//
//  Created by Andy Bezaire on 16.3.2021.
//

import Combine
import os.log

public extension Publisher {
    /// Use this to log the output  and life cycle of a publisher to a custom log message.
    ///
    /// Lifecycle methods are logged appropriately as:
    /// - `receiveSubscription: <prefix> started`
    /// - `receiveCompletion.failure: <prefix> error: <error>`
    /// - `receiveCompletion.finished: <prefix> finished`
    /// - `receiveCancel: <prefix> cancelled`
    ///
    /// use the logger in the completion to log an appropriate message and optionally select the privacy of the output
    ///
    /// Usage:
    ///
    ///     let logger = Logger(subsystem: "com.example.subsystem", category: "main")
    ///
    ///     let cancel = [1, 2, 3].publisher
    ///         .log(to: logger, prefix: "Counter") { logger, output in
    ///             logger.log("Counter got \(output, privacy: .private) new coin(s)")
    ///         }
    ///         .sink { _ in } receiveValue: { _ in }
    ///
    ///      // sample output:
    ///      // 2021-03-16 20:41:10.980102+0200 subsystem[47288:1810254] [main] Counter started
    ///      // 2021-03-16 20:41:10.980252+0200 subsystem[47288:1810254] [main] Counter got 1 new coin(s)
    ///      // 2021-03-16 20:41:10.980361+0200 subsystem[47288:1810254] [main] Counter got 2 new coin(s)
    ///      // 2021-03-16 20:41:10.980451+0200 subsystem[47288:1810254] [main] Counter got 3 new coin(s)
    ///      // 2021-03-16 20:41:10.980578+0200 subsystem[47288:1810254] [main] Counter finished
    /// - Parameters:
    ///   - logger: the optional logger to log to
    ///   - prefix: the prefixed text before any of the lifecycle methods
    ///   - logCommand: a closure which can be used to log the output appropriately
    /// - Returns: a publisher similar to the upstream publisher
    func log(
        to logger: Logger?,
        prefix: String,
        _ logCommand: @escaping ((Logger, Output) -> Void)
    ) -> AnyPublisher<Output, Failure> {
        guard let logger = logger else { return self.handleEvents().eraseToAnyPublisher() }

        let receiveSubscription: ((Subscription) -> Void) = { _ in
            logger.log("\(prefix, privacy: .public) started")
        }

        let receiveCompletion: ((Subscribers.Completion<Self.Failure>) -> Void) = { completion in
            switch completion {
            case .failure(let error):
                logger.log(
                    level: .error,
                    "\(prefix, privacy: .public) error: \(error.localizedDescription, privacy: .public)"
                )
            case .finished:
                logger.log("\(prefix, privacy: .public) finished")
            }
        }

        let receiveOutput: ((Output) -> Void) = { output in
            logCommand(logger, output)
        }

        let receiveCancel: (() -> Void) = {
            logger.log("\(prefix, privacy: .public) cancelled")
        }

        return self.handleEvents(
            receiveSubscription: receiveSubscription,
            receiveOutput: receiveOutput,
            receiveCompletion: receiveCompletion,
            receiveCancel: receiveCancel
        )
        .eraseToAnyPublisher()
    }

    /// Use this to log only the output of a publisher to a custom log message.
    ///
    /// Usage:
    ///
    ///     let logger = Logger(subsystem: "com.example.subsystem", category: "main")
    ///
    ///     let cancel = [1, 2, 3].publisher
    ///         .log(to: logger, prefix: "Counter") { logger, output in
    ///             logger.log("Counter got \(output, privacy: .private) new coin(s)")
    ///         }
    ///         .sink { _ in } receiveValue: { _ in }
    ///
    ///      // sample output:
    ///      // 2021-03-16 20:41:10.980252+0200 subsystem[47288:1810254] [main] Counter got 1 new coin(s)
    ///      // 2021-03-16 20:41:10.980361+0200 subsystem[47288:1810254] [main] Counter got 2 new coin(s)
    ///      // 2021-03-16 20:41:10.980451+0200 subsystem[47288:1810254] [main] Counter got 3 new coin(s)
    /// - Parameters:
    ///   - logger: the optional logger to log to
    ///   - logCommand: a closure which can be used to log the output appropriately
    /// - Returns: a publisher similar to the upstream publisher
    func logOutput(
        to logger: Logger?,
        _ logCommand: @escaping ((Logger, Output) -> Void)
    ) -> AnyPublisher<Output, Failure> {
        let receiveOutput = logger
            .map { logger in { output in logCommand(logger, output) } }
        return self
            .handleEvents(receiveOutput: receiveOutput)
            .eraseToAnyPublisher()
    }
}
