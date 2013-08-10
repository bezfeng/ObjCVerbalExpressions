ObjCVerbalExpressions
=====================

## Obj-C Regular Expressions made easy
VerbalExpressions helps to construct difficult regular expressions.

This Obj-C implementation is based off of the (original) Javascript [VerbalExpressions](https://github.com/jehna/VerbalExpressions) library by [jehna](https://github.com/jehna/).

## How to get started

Import BEZVerEx.h and BEZVerEx.m into your existing project. This project currently only supports ARC environments.

## Basic usage
Declare a BEZVerEx object using either a convenience method or a standard alloc/init combo. Method calls can then be chained onto this object to create your final expression.

```objective-c
BEZVerEx *verEx = [BEZVerEx expression];
```

## Examples

Here's a couple of simple examples to give an idea of how VerbalExpressions works:

### Testing if we have a valid URL

```objective-c
// Create an example of how to test for correctly formed URLs
BEZVerEx *expr = [[[[[[[[[[BEZVerEx expression]
							searchOneLine]
							withAnyCase]
							startOfLine]
							 then:@"http"]
							maybe:@"s"]
							 then:@"://"]
							maybe:@"www."]
					  anythingBut:@" "]
							endOfLine];

// Use the test function to find how many matches were returned
NSLog(@"URL matched: %li", (unsigned long)[verEx test:@"https://www.google.com"]);

NSLog(@"Expression used to match above: %@", verEx.expression);
```

### Replacing strings

```objective-c
// Create a test string
NSString *input = @"Find the mouse and switch him.";
// Create an expression that searches for "mouse""
BEZVerEx *verEx2 = [[BEZVerEx expression] find:@"mouse"];
// Execute the expression
NSLog(@"%@", [verEx2 replaceSource:input withValue:@"bird"]);
```

## Notes
ObjC's message sending syntax can make construction of VerEx rather ugly, and I'm trying to find a more elegant way to chain commands.

The range method expects a nil terminated list of string pairs like so:

```objective-c
BEZVerEx *rangeEx = [[BEZVerEx expression] range:@"a", @"b", "c", "g", nil];
```

If there is an odd number of range arguments, the VerEx will ignore the range modifier and print a warning to the console.