//
//  main.m
//  VerbalExpressions
//
//  Created by Feng, Bezhou on 8/9/13.
//
//

#import <Foundation/Foundation.h>
#import "BEZVerEx.h"

int main(int argc, const char * argv[])
{
  
  @autoreleasepool {
    NSLog(@"Hello, World!");
    
    BEZVerEx *verEx = [[[[[[[[[[BEZVerEx expression] searchOneLine] withAnyCase] startOfLine] then:@"http"] maybe:@"s"] then:@"://"] maybe:@"www"] anythingBut:@" "] endOfLine];
    
    NSLog(@"URL matched: %li", (unsigned long)[verEx test:@"https://www.google.com"]);
    NSLog(@"URL matched: %li", (unsigned long)[verEx test:@"http://www.google.com"]);
    NSLog(@"URL matched: %li", (unsigned long)[verEx test:@"ftp://www.google.com"]);
    
    NSLog(@"Expression used to match above: %@", verEx.expression);
    
    BEZVerEx *verEx2 = [[[BEZVerEx expression] find:[[[[BEZVerEx expression] find:@"http"] maybe:@"s"] OR:@"ftp"].expression] then:@"://"];
    
    NSLog(@"URL matched: %li", (unsigned long)[verEx2 test:@"https://www.google.com"]);
    NSLog(@"URL matched: %li", (unsigned long)[verEx2 test:@"ftp://www.google.com"]);
    
    NSLog(@"Expression used to match above: %@", verEx2.expression);
    
    BEZVerEx *verEx3 = [[[[[BEZVerEx expression] withAnyCase] then:@"te"] withAnyCase:NO] then:@"st"];
    
    NSLog(@"test matched: %li", (unsigned long)[verEx3 test:@"test"]);
    NSLog(@"TEst matched: %li", (unsigned long)[verEx3 test:@"TEst"]);
    NSLog(@"teST matched: %li", (unsigned long)[verEx3 test:@"teST"]);
  }
  return 0;
}

