# CombineExtras

Some handy extras to use alongside the Combine/OpenCombine framework.
Including:
- AnySubject

## Usage

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
.package(url: "https://github.com/andybezaire/CombineExtras.git, from: "1.0")
```
## License

Authorization is available under the MIT license. See the LICENSE file for more info.


## Credit

Copyright (c) 2021 andybezaire

Created by: Andy Bezaire
