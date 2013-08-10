//
//  VerEx.m
//  VerbalExpressions
//
//  Created by Feng, Bezhou on 8/9/13.
//
//

#import "BEZVerEx.h"

@interface BEZVerEx ()

@property (strong, nonatomic) NSMutableString *prefixes;
@property (strong, nonatomic) NSMutableString *source;
@property (strong, nonatomic) NSMutableString *suffixes;
@property (strong, nonatomic) NSMutableString *pattern;

@end

@implementation BEZVerEx

+ (BEZVerEx *)expression {
  BEZVerEx *expression = [[BEZVerEx alloc] init];
  return expression;
}

- (id)init {
  self = [super init];
  if (self) {
    self.prefixes = [NSMutableString string];
    self.source = [NSMutableString string];
    self.suffixes = [NSMutableString string];
    self.pattern = [NSMutableString string];
  }
  return self;
}

- (NSString *)expression {
  return [NSString stringWithString:self.pattern];
}

#pragma mark - Direct Expression Operations

- (BEZVerEx *)add:(NSString *)string {
  [self.source appendString:string];
  self.pattern = [NSMutableString stringWithFormat:@"%@%@%@", self.prefixes, self.source, self.suffixes];
  return self;
}

#pragma mark - Searches and Characters

/* Match start of line */
- (BEZVerEx *)startOfLine:(BOOL)enable {
  self.prefixes = (enable) ? [@"^" mutableCopy] : [@"" mutableCopy];
  return [self add:@""];
}

- (BEZVerEx *)startOfLine {
  return [self startOfLine:YES];
}

/* Match end of line */
- (BEZVerEx *)endOfLine:(BOOL)enable {
  self.suffixes = (enable) ? [@"$" mutableCopy] : [@"" mutableCopy];
  return [self add:@""];
}

- (BEZVerEx *)endOfLine {
  return [self endOfLine:YES];
}

- (BEZVerEx *)lineBreak {
  return [self add:@"(?:(?:\\n)|(?:\\r\\n))"];
}

- (BEZVerEx *)br {
  return [self lineBreak];
}

- (BEZVerEx *)tab {
  return [self add:@"\\t"];
}

- (BEZVerEx *)word {
  return [self add:@"\\w+"];
}

- (BEZVerEx *)then:(NSString *)string {
  return [self add:[NSString stringWithFormat:@"(?:%@)", string]];
}

- (BEZVerEx *)find:(NSString *)string {
  return [self then:string];
}

/* Match string zero or one time */
- (BEZVerEx *)maybe:(NSString *)string {
  return [self add:[NSString stringWithFormat:@"(?:%@)?", string]];
}

- (BEZVerEx *)anything {
  return [self add:@"(?:.*)"];
}

- (BEZVerEx *)anythingBut:(NSString *)string {
  return [self add:[NSString stringWithFormat:@"(?:[^%@]*)", string]];
}

- (BEZVerEx *)something {
  return [self add:@"(?:.+)"];
}

- (BEZVerEx *)somethingBut:(NSString *)string {
  return [self add:[NSString stringWithFormat:@"(?:[^%@]+)", string]];
}

- (BEZVerEx *)anyOf:(NSString *)string {
  return [self add:[NSString stringWithFormat:@"[%@]", string]]; 
}

- (BEZVerEx *)any:(NSString *)string {
  return [self anyOf:string];
}

- (BEZVerEx *)rangeFrom:(NSString *)from, ... {
  va_list args;
  if (from) {
    NSMutableString *rangeString = [NSMutableString stringWithFormat:@"["];
    int argCount = 1;
    
    va_start(args, from);
    NSString *s;
    NSString *to;
    for (s = from, to = va_arg(args, NSString *); s != nil && to != nil; s = va_arg(args, NSString *), to = va_arg(args, NSString *)) {
      [rangeString appendFormat:@"%@-%@", s, to];
      argCount++;
    }
    va_end(args);
    
    if (argCount % 2 == 0) {
      [rangeString appendString:@"]"];
      [self add:rangeString];
    } else {
      NSLog(@"WARNING: range must be called on complete pairs of arguments only, ignoring range modifier");
    }
  }
  return self;
}

- (BEZVerEx *)multiple:(NSString *)string {
  NSString *addition = @"";
  if ([string characterAtIndex:0] != '*' && [string characterAtIndex:0] != '+') {
    addition = @"+";
  }
  return [self add:[NSString stringWithFormat:@"%@%@", addition, string]];
}

- (BEZVerEx *)OR:(NSString *)string {
  if ([self.prefixes rangeOfString:@"("].location == NSNotFound) [self.prefixes appendString:@"("];
  if ([self.suffixes rangeOfString:@")"].location == NSNotFound) [self.suffixes appendString:@")"];
  [self add:@")|("];
  return [self then:string];
}

#pragma mark - Modifiers

- (BEZVerEx *)withAnyCase:(BOOL)enable {
  if (enable) [self add:@"(?i)"];
  else [self add:@"(?-i)"];
  return self;
}

- (BEZVerEx *)withAnyCase {
  return [self withAnyCase:YES];
}

- (BEZVerEx *)searchOneLine:(BOOL)enable {
  if (enable) [self add:@"(?m)"];
  else [self add:@"(?-m)"];
  return self;
}

- (BEZVerEx *)searchOneLine {
  return [self searchOneLine:YES];
}

#pragma mark - Actions
- (NSString *)replaceSource:(NSString *)source withValue:(NSString *)value {
  NSError *error;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.pattern options:0 error:&error];
  if (error) {
    NSLog(@"ERROR: Could not parse constructed pattern into a valid regex [%@]", error);
    return nil;
  }
  
  return [regex stringByReplacingMatchesInString:source options:0 range:NSMakeRange(0, source.length) withTemplate:value];
}

- (NSUInteger)test:(NSString *)string {
  NSError *error;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.pattern options:0 error:&error];
  if (error) {
    NSLog(@"ERROR: Could not parse constructed pattern into a valid regex [%@]", error);
    return 0;
  }
  return [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
}

@end
