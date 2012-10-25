//
//  NSMutableURLRequest+BasicAuthentication.h
//  NSURLRequest+BasicAuthentication
//
//  Created by Dan Zinngrabe on 10/24/12.
//  Copyright (c) 2012 Dan Zinngrabe. All rights reserved.
//

#ifndef __NSMUTABLEURLREQUEST_BASICAUTHENTICATION_H__
#define __NSMUTABLEURLREQUEST_BASICAUTHENTICATION_H__

#import <Foundation/Foundation.h>

#if PRAGMA_ONCE
#pragma once
#endif

@interface NSMutableURLRequest (BasicAuthentication)

/*!
 
 setHTTPBasicAuthUsername:password
 
 @abstract Sets the Basic Auth username and password for this request.
 @discussion NSURLConnection by design waits for authentication to fail before providing credentials. In our application, this would cause some failures. TAP, for example, would kick us out on the initial authentication failure. As a result, we have to pre-fill the authentication headers for some requests. This method does that.
 
 @param username Username for the request.
 @param password Password for the request.
 */

- (void)setHTTPBasicAuthUsername:(NSString *)username password:(NSString *)password;

@end
#endif
