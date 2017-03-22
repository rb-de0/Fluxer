# Fluxer

[![apm](https://img.shields.io/apm/l/vim-mode.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/rb-de0/Fluxer.svg?branch=master)](https://travis-ci.org/rb-de0/Fluxer)
[![Coverage Status](https://coveralls.io/repos/github/rb-de0/Fluxer/badge.svg?branch=master)](https://coveralls.io/github/rb-de0/Fluxer?branch=master)

Swift Flux Framework

## Requirements

- Swift 3.0.2
- Xcode 8.2.1
- iOS 9.0 or later

## Installation

### Carthage

```bash
github "rb-de0/Fluxer"
```

## Usage

### Store

Store maintains the status of applications and screens.
Please define as follows.

```Swift
class MainStore: Store {
    let value = ObservableValue(0)
}

let mainStore = MainStore()
```

### Dispatcher

Dispatcher manages multiple ActionHandlers and changes a state of a Store.
Please instantiate as follows.

```Swift
let dispacher = Dispatcher(store: mainStore)
```

In the Dispatcher a Store is held with weak references, so you need to keep it in a different location.

#### Registration ActionHandler

ActionHandler changes a Store from a current Store and a Action.
Action has data to change Store.
Please register as follows.

```Swift
struct HogeAction: Action {}

let token = dispacher.register { action, store in
    store.value.value = 10
}

dispatcher.dispatch(HogeAction())
```

#### AsyncActionCreator

Dispatcher can dispatch actions asynchronously.
Please register as follows.

```Swift
dispatcher.dispatch { store, callback in
    callback { store in HogeAction() }
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

## Future Improvement

- Docs
- CocoaPods

## Author

[rb_de0](https://twitter.com/rb_de0), rebirth.de0@gmail.com

## License

Fluxer is available under the MIT license. See the LICENSE file for more info.
