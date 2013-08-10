//
//  VerEx.h
//  VerbalExpressions
//
//  Created by Feng, Bezhou on 8/9/13.
//
//

#import <Foundation/Foundation.h>

@interface BEZVerEx : NSObject

// returns actual expression used in regex
@property (readonly) NSString *expression;

+ (BEZVerEx *)expression;

- (BEZVerEx *)add:(NSString *)string;

- (BEZVerEx *)startOfLine:(BOOL)enable;
- (BEZVerEx *)startOfLine;
- (BEZVerEx *)endOfLine:(BOOL)enable;
- (BEZVerEx *)endOfLine;

- (BEZVerEx *)lineBreak;
- (BEZVerEx *)br;
- (BEZVerEx *)tab;
- (BEZVerEx *)word;

- (BEZVerEx *)then:(NSString *)string;
- (BEZVerEx *)find:(NSString *)string;
- (BEZVerEx *)maybe:(NSString *)string;
- (BEZVerEx *)anything;
- (BEZVerEx *)anythingBut:(NSString *)string;
- (BEZVerEx *)something;
- (BEZVerEx *)somethingBut:(NSString *)string;
- (BEZVerEx *)anyOf:(NSString *)string;
- (BEZVerEx *)any:(NSString *)string;
- (BEZVerEx *)rangeFrom:(NSString *)from, ...;

- (BEZVerEx *)withAnyCase:(BOOL)enable;
- (BEZVerEx *)withAnyCase;
- (BEZVerEx *)searchOneLine:(BOOL)enable;
- (BEZVerEx *)searchOneLine;

- (BEZVerEx *)multiple:(NSString *)string;
- (BEZVerEx *)OR:(NSString *)string;

- (NSString *)replaceSource:(NSString *)source withValue:(NSString *)value;
- (NSUInteger)test:(NSString *)string;

@end
