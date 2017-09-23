# Fluxer

[![apm](https://img.shields.io/apm/l/vim-mode.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Version](https://img.shields.io/cocoapods/v/Fluxer.svg?style=flat)](http://cocoapods.org/pods/Fluxer)
[![Build Status](https://travis-ci.org/rb-de0/Fluxer.svg?branch=master)](https://travis-ci.org/rb-de0/Fluxer)
[![Coverage Status](https://coveralls.io/repos/github/rb-de0/Fluxer/badge.svg?branch=master)](https://coveralls.io/github/rb-de0/Fluxer?branch=master)


Swift Flux Framework

## Requirements

- Swift 3.1 or lator
- Xcode 8.3.3 or lator
- iOS 9.0 or later

## Installation

### Carthage

```bash
github "rb-de0/Fluxer"
```

### CocoaPods

Fluxer is available through CocoaPods. To install it, simply add the following line to your Podfile:

```
pod 'Fluxer'
```

## Usage

### Store

Store maintains the status of applications and screens.
Please define as follows.

```Swift
class MainStore: Store {
    let value = ObservableValue(0)
    
    required init(with dispatcher: Dispatcher) {
    }
}

let mainStore = MainStore(with: dispatcher)
```

In Store initializer, please register ActionHandler in dispatcher. The description of ActionHandler is below.

### Dispatcher

Dispatcher manages multiple ActionHandlers and tells Actions to Action.
Please instantiate as follows.

```Swift
let dispacher = Dispatcher()
```

#### Registration ActionHandler

ActionHandler changes a Store from a dispatched Action.
Action has data to change Store.
Please register as follows.

```Swift
struct HogeAction: Action {}

class MainStore: Store {
    let value = ObservableValue(0)
    
    required init(with dispatcher: Dispatcher) {
        let token = dispacher.register { [weak self] action in
            self?.value.value = 10
        }
    }
}

let dispacher = Dispatcher()
let mainStore = MainStore(with: dispatcher)

dispatcher.dispatch(HogeAction())
```

#### AsyncActionCreator

Dispatcher can dispatch actions asynchronously.
Please register as follows.

```Swift
dispatcher.dispatch { callback in

	 // do background tasks
    callback(HogeAction())
}
```

#### waitFor

By using waitFor method in a Dispatcher, you can control the order of calling ActionHandler.

### Observable

In Fluxer, we use Observable to subscribe states of a Store.

#### ObservableValue

```Swift
let value = ObservableValue(0)
```

ObservableValue is a Observable that holds the value. You need to change the value property.

#### Render

```Swift
let value = ObservableValue(0)

let disposable = value.asRender().subscribe { _ in
    print(Thread.isMainThread) // => true
}

DispatchQueue.global().async {
    value.value = 10
}
```

Render is an Observable that can be generated from other Observable.
Methods that handle a Render changes are always executed in UI threads.

### Disposable

Disposable is an object that manages Observable subscriptions. In Fluxer, you can use two Disposables.

#### BlockDisposable

Disposable executing Block when dispose is called.

#### CompositeDisposable

Disposable which manages multiple Disposables.

### DisposeBag


DisposeBag manages Disposable according to the life cycle.

```Swift

var disposeBag = DisposeBag()

let value = ObservableValue(0)

value.subscribe {
    print($0)
}.addTo(disposeBag)

disposeBag = DisposeBag() // dispose

```

### Operator

Fluxer provides a few operators for Observable. Operators will be added in the future.

#### Map

Map is an operator that converts Observable values ​​to arbitrary types.

```Swift
let value = ObservableValue(0)
value.map { $0 + 1 }.subscribe {
    print($0)
}
```

#### Filter

Filter is an operator that flows only values ​​that satisfy the specified conditions.

```Swift
let value = ObservableValue(0)
value.filter { $0 >= 0 }.subscribe {
    print($0)
}
```

#### Combine

Map and Filter can be used in combination.

```Swift
let value = ObservableValue(0)
value.map { $0 + 1 }.filter { $0 >= 0 }.subscribe {
    print($0)
}
```

## Future Improvement

- Docs
- SomeOperator
- Swift Package Manager Tests

## Author

[rb_de0](https://twitter.com/rb_de0), rebirth.de0@gmail.com

## License

Fluxer is available under the MIT license. See the LICENSE file for more info.
