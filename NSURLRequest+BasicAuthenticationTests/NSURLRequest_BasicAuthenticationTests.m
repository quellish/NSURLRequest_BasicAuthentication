//
//  NSURLRequest_BasicAuthenticationTests.m
//  NSURLRequest+BasicAuthenticationTests
//
//  Created by Dan Zinngrabe on 10/24/12.
//  Copyright (c) 2012 Dan Zinngrabe. All rights reserved.
//

#import "NSURLRequest_BasicAuthenticationTests.h"
#import <UnitTestHTTPServer/HTTPServer.h>
#import <UnitTestHTTPServer/HTTPConnection.h>

@interface AuthenticatedConnection : HTTPConnection

@end

@implementation AuthenticatedConnection

- (BOOL)isPasswordProtected:(NSString *)path {

    return YES;
}

- (BOOL)useDigestAccessAuthentication {
    return NO;
}

- (NSString *)passwordForUser:(NSString *)username {

    return @"secret";
}

@end

@interface NSURLRequest_BasicAuthenticationTests()
@property (nonatomic, retain) HTTPServer *httpServer;
@end

@implementation NSURLRequest_BasicAuthenticationTests
@synthesize httpServer;

- (void)setUp
{
    NSError     *error  = nil;
    HTTPServer  *server = nil;
    [super setUp];
    
    // Set-up code here.
    server = [[HTTPServer alloc] init];
    [server setType:@"_http._tcp."];
    [server setConnectionClass:[AuthenticatedConnection class]];
    [self setHttpServer:server];
    if([httpServer start:&error]) {
        NSLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
    } else {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
    [server release];
}

- (void)tearDown
{
    // Tear-down code here.
    [[self httpServer] stop];
    [httpServer release];
    
    [super tearDown];
}

- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in NSURLRequest+BasicAuthenticationTests");
}

@end
