//
//  NSMutableURLRequest+BasicAuthentication.m
//  NSURLRequest+BasicAuthentication
//
//  Created by Dan Zinngrabe on 10/24/12.
//  Copyright (c) 2012 Dan Zinngrabe. All rights reserved.
//

#import "NSMutableURLRequest+BasicAuthentication.h"

@implementation NSMutableURLRequest (BasicAuthentication)

- (void)setHTTPBasicAuthUsername:(NSString *)username password:(NSString *)password {
    NSString            *result = nil;
	CFHTTPMessageRef    throwawayRequest = NULL;
	CFURLRef            throwawayURL = NULL;
	
	if (username != nil && password != nil){
		//throwawayURL = CFURLCreateWithString(kCFAllocatorDefault, CFSTR("http://192.168.1.1"), NULL);
        throwawayURL = (CFURLRef)[self URL];
        if (throwawayURL != NULL){
			// Create a new request to handle the proper creation of the header
			throwawayRequest = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"),throwawayURL, kCFHTTPVersion1_1);
			if (throwawayRequest != NULL){
				CFHTTPMessageAddAuthentication(throwawayRequest, nil,(CFStringRef)username,(CFStringRef)password,kCFHTTPAuthenticationSchemeBasic,FALSE);
				result = (NSString *)CFHTTPMessageCopyHeaderFieldValue(throwawayRequest,CFSTR("Authorization"));
                
                // No safer, cleaner way yet. You'd think copying from the throwaway would work!
                [self setValue:result forHTTPHeaderField:@"Authorization"];
                [result release];
                
				CFRelease(throwawayRequest);
			}
            //CFRelease(throwawayURL);
		}
	}
}

@end
