//
//  NSURLRequest_BasicAuthenticationTests.m
//  NSURLRequest+BasicAuthenticationTests
//
//  Created by Dan Zinngrabe on 10/24/12.
//  Copyright (c) 2012 Dan Zinngrabe. All rights reserved.
//

#import "NSURLRequest_BasicAuthenticationTests.h"
#import "NSMutableURLRequest+BasicAuthentication.h"
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

//
- (void)testSimpleConnection
{
    NSString            *urlString      = nil;
    NSURL               *url            = nil;
    NSURLRequest        *request        = nil;
    NSData              *data           = nil;
    NSURLResponse       *response       = nil;
    NSError             *error          = nil;
    
    urlString = [[NSString alloc] initWithFormat:@"http://user:secret@127.0.0.1:%d/index.html", [[self httpServer] listeningPort] ];
    url = [NSURL URLWithString:urlString];
    request = [NSURLRequest requestWithURL:url];
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    STAssertNil(error, @"Server returned error");
}

// This should fail
- (void)testSimpleConnectionAuthenticationFail
{
    NSString            *urlString      = nil;
    NSURL               *url            = nil;
    NSURLRequest        *request        = nil;
    NSData              *data           = nil;
    NSURLResponse       *response       = nil;
    NSError             *error          = nil;
    
    urlString = [[NSString alloc] initWithFormat:@"http://user:secretzz@127.0.0.1:%d/index.html", [[self httpServer] listeningPort] ];
    url = [NSURL URLWithString:urlString];
    request = [NSURLRequest requestWithURL:url];
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    STAssertNotNil(error, @"Server did not return error");
}

// Tests our category
- (void)testBasicAuthentication
{
    NSString            *urlString      = nil;
    NSURL               *url            = nil;
    NSMutableURLRequest *request        = nil;
    NSData              *data           = nil;
    NSURLResponse       *response       = nil;
    NSError             *error          = nil;
    
    urlString = [[NSString alloc] initWithFormat:@"http://127.0.0.1:%d/index.html", [[self httpServer] listeningPort] ];
    url = [NSURL URLWithString:urlString];
    request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPBasicAuthUsername:@"user" password:@"secret"];
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    STAssertNil(error, @"Server returned error");
}

// Demonstrates using an NSURLCredential for basic authentication.
- (void)testURLCredential
{
    NSString                *urlString          = nil;
    NSURL                   *url                = nil;
    NSMutableURLRequest     *request            = nil;
    NSData                  *data               = nil;
    NSURLResponse           *response           = nil;
    NSError                 *error              = nil;
    NSURLProtectionSpace    *protectionSpace    = nil;
    NSURLCredential         *credential         = nil;
    
    urlString = [[NSString alloc] initWithFormat:@"http://127.0.0.1:%d/index.html", [[self httpServer] listeningPort] ];
    url = [NSURL URLWithString:urlString];
    
    credential = [NSURLCredential credentialWithUser:@"user" password:@"secret" persistence: NSURLCredentialPersistencePermanent];
    protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:[url host] port:[[url port] integerValue] protocol:[url scheme] realm:nil authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    [[NSURLCredentialStorage sharedCredentialStorage] setCredential:credential forProtectionSpace:protectionSpace];

    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:credential forProtectionSpace:protectionSpace];
    [protectionSpace release];

    STAssertNil(error, @"Server returned error");
}

@end
