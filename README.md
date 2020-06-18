# Lognito

Ultimate logging library.

Lognito is the last logging library for dart you need.
Lognito manages to do everything from simple logs to beautiful async logging.
It was designed with customization in mind.\
Inspired by [Logger](https://pub.dev/packages/logger).

**All feedback is welcomed.**

## Getting started

Just init `Lognito` and start logging:

```dart
var logger = Lognito.init();

logger.d("Logger is working!");
```
You can pass any object and formatter will take care of formatting it to `String`. \
But `PrettyFormatter` and `SimpleFormatter` can format only work with `String`,`List` and `Map`.


## Documentation

### Instances
Lognito is based around singleton pattern, by first calling `Lognito.init()` you create the initial configuration,
where you have to provide all the configuration.
Then you can either call constructor `Lognito()` to get the same instance, or `Lognito.withLabel()` to create labeled instance.
This has the same configuration, but has label ten identifies it.

Lognito is separated into three main layers.\
For every layer we provide few simple implementations, but every layer can be swapped with your own implementation.

### Filters
First layer.\
Decides if event should go to buffers.

`DevelopmentFilter` return true for event with higher or same level as defined by the constructor parameter.

### Buffers
This is the main layer.\
Buffers collect logged events and store them in internal buffer until flush is called.\

`Buffer.flush()` is asynchronous function to allow logging to api.

Implemented buffers
* `SimpleBuffer` - immediately to the outputs
* `RepeatingBuffer` - ensures all logs are successfully send to all outputs
* `LevelDelayedBuffer` - extends `RepeatingBuffer`. Stores events until certain event level is logged, then sends out all stored events.

### Outputs
Last layer.\
Output is where all the magic happens. \
Takes the `LogEvent` and send it's to the final destination.

* `ConsoleOutput` - simply prints out the formatter event
* `DebugPrinterOutput` - same as `ConsoleOutput` but uses `debugPrint`
* `FileOutput` - append formatted lines to the given file
* `HTTPOutput` - send a formatted event to api

### Formatters
Formats the event to pretty or right format in outputs.\

* `SimpleFormatter` - simple message formatting
* `PrettyFormatter` - pretty console output formatting with stack trace
* `JsonFormatter` - formats message with json encode

#### Credits

Huge shout out to [Leisim](https://github.com/leisim) his library was great inspiration.\
PS: Thanks for few of your classes.