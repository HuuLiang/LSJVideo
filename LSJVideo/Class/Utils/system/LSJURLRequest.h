//
//  LSJURLRequest.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSJURLResponse.h"

typedef NS_ENUM(NSUInteger, LSJURLResponseStatus) {
    LSJURLResponseSuccess,
    LSJURLResponseFailedByInterface,
    LSJURLResponseFailedByNetwork,
    LSJURLResponseFailedByParsing,
    LSJURLResponseFailedByParameter,
    LSJURLResponseNone
};

typedef NS_ENUM(NSUInteger, LSJURLRequestMethod) {
    LSJURLGetRequest,
    LSJURLPostRequest
};

typedef void (^LTURLResponseHandler)(LSJURLResponseStatus respStatus, NSString *errorMessage);

@interface LSJURLRequest : NSObject

@property (nonatomic,retain) id response;

+ (Class)responseClass;  // override this method to provide a custom class to be used when instantiating instances of LTURLResponse
+ (BOOL)shouldPersistURLResponse;
- (NSURL *)baseURL; // override this method to provide a custom base URL to be used
- (NSURL *)standbyBaseURL; // override this method to provide a custom standby base URL to be used

- (BOOL)shouldPostErrorNotification;
- (LSJURLRequestMethod)requestMethod;

- (BOOL)requestURLPath:(NSString *)urlPath withParams:(NSDictionary *)params responseHandler:(LTURLResponseHandler)responseHandler;

- (BOOL)requestURLPath:(NSString *)urlPath standbyURLPath:(NSString *)standbyUrlPath withParams:(NSDictionary *)params responseHandler:(LTURLResponseHandler)responseHandler;

// For subclass pre/post processing response object
- (void)processResponseObject:(id)responseObject withResponseHandler:(LTURLResponseHandler)responseHandler;

@end
