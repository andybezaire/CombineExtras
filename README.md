# CombineExtras

Some handy extras to use alongside the Combine/OpenCombine framework.
Including:
- AnySubject

## Usage

### Publisher.log(...)
Use this to log the output and events of a publisher to a lgger with a  custom log message.

    let logger = Logger(subsystem: "com.example.subsystem", category: "main")

    let counting = [1, 2, 3].publisher
        .log(to: logger, prefix: "Counter") { logger, output in
            logger.log("Counter got \(output, privacy: .private) new coin(s)")
        }
        .sink { _ in } receiveValue: { _ in }

    // sample output:
    // 2021-03-16 20:41:10.980102+0200 subsystem[47288:1810254] [main] Counter started
    // 2021-03-16 20:41:10.980252+0200 subsystem[47288:1810254] [main] Counter got 1 new coin(s)
    // 2021-03-16 20:41:10.980361+0200 subsystem[47288:1810254] [main] Counter got 2 new coin(s)
    // 2021-03-16 20:41:10.980451+0200 subsystem[47288:1810254] [main] Counter got 3 new coin(s)
    // 2021-03-16 20:41:10.980578+0200 subsystem[47288:1810254] [main] Counter finished

### URLSession.loggingDataTask(...)
Creates a publisher that wraps a URL session data task for a given URL request,
printing the request and response with one liners to a logger.

    let logger = Logger(subsystem: "com.example.subsystem", category: "main")

    let url = URL(string: "http://example.com")!
    let request = URLRequest(url: url)

    let fetching = URLSession.shared.loggingDataTask(for: request, using: logger, prefix: "Eg.")
    .sink { _ in  } receiveValue: { _ in }
    }

    // sample output:
    // 2021-04-05 10:31:11.056163+0300 subsystem[20738:1225036] [main] Eg. request: GET http://example.com
    // 2021-04-05 10:31:11.061316+0300 subsystem[20738:1225067] [main] Eg. response: 200 http://example.com  27 byte(s)

### AnySubject

    var subject: AnySubject<String, Never>
    
    // variable can contain different subject types:
    subject = PassthroughSubject<String, Never>().eraseToAnySubject()
    subject = CurrentValueSubject<String, Never>("").eraseToAnySubject()
    
    // type hidden
    let resolvesToNil = PassthroughSubject<String, Never>().eraseToAnySubject() as? PassthroughSubject<String, Never>

## Installation

### Swift Package Manager

Add the following dependency to your **Package.swift** file:

```swift
.package(name: "CombineExtras", url: "https://github.com/andybezaire/CombineExtras.git", from: "1.2.0")
```
## License

Authorization is available under the MIT license. See the LICENSE file for more info.


## Credit

Copyright (c) 2021 andybezaire

Created by: Andy Bezaire
