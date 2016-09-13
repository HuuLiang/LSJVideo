//
//  LSJURLRequest.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJURLRequest.h"
#import <AFNetworking.h>

@interface LSJURLRequest ()
@property (nonatomic,retain) AFHTTPRequestOperationManager *requestOpManager;
@property (nonatomic,retain) AFHTTPRequestOperation *requestOp;

@property (nonatomic,retain) AFHTTPRequestOperationManager *standbyRequestOpManager;
@property (nonatomic,retain) AFHTTPRequestOperation *standbyRequestOp;

-(BOOL)requestURLPath:(NSString *)urlPath
           withParams:(NSDictionary *)params
            isStandby:(BOOL)isStandBy
    shouldNotifyError:(BOOL)shouldNotifyError
      responseHandler:(LTURLResponseHandler)responseHandler;
@end

@implementation LSJURLRequest

+ (Class)responseClass {
    return [LSJURLResponse class];
}

+ (BOOL)shouldPersistURLResponse {
    return NO;
}

+ (NSString *)persistenceFilePath {
    NSString *fileName = NSStringFromClass([self responseClass]);
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.plist", [NSBundle mainBundle].resourcePath, fileName];
    return filePath;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([[[self class] responseClass] isSubclassOfClass:[LSJURLResponse class]]) {
            NSDictionary *lastResponse = [NSDictionary dictionaryWithContentsOfFile:[[self class] persistenceFilePath]];
            if (lastResponse) {
                LSJURLResponse *urlResponse = [[[[self class] responseClass] alloc] init];
                [urlResponse parseResponseWithDictionary:lastResponse];
                self.response = urlResponse;
            }
        }
        
    }
    return self;
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:LSJ_BASE_URL];
}

- (NSURL *)standbyBaseURL {
    return nil;
}

- (BOOL)shouldPostErrorNotification {
    return YES;
}

- (LSJURLRequestMethod)requestMethod {
    return LSJURLGetRequest;
}

-(AFHTTPRequestOperationManager *)requestOpManager {
    if (_requestOpManager) {
        return _requestOpManager;
    }
    
    _requestOpManager = [[AFHTTPRequestOperationManager alloc]
                         initWithBaseURL:[self baseURL]];
    return _requestOpManager;
}

- (AFHTTPRequestOperationManager *)standbyRequestOpManager {
    if (_standbyRequestOpManager) {
        return _standbyRequestOpManager;
    }
    
    _standbyRequestOpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[self standbyBaseURL]];
    return _standbyRequestOpManager;
}

-(BOOL)requestURLPath:(NSString *)urlPath
           withParams:(NSDictionary *)params
            isStandby:(BOOL)isStandBy
    shouldNotifyError:(BOOL)shouldNotifyError
      responseHandler:(LTURLResponseHandler)responseHandler
{
    if (urlPath.length == 0) {
        if (responseHandler) {
            responseHandler(LSJURLResponseFailedByParameter, nil);
        }
        return NO;
    }
    
    DLog(@"Requesting %@ !\nwith parameters: %@\n", urlPath, params);
    
    @weakify(self);
    self.response = [[[[self class] responseClass] alloc] init];
    
    void (^success)(AFHTTPRequestOperation *,id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);
        
        DLog(@"Response for %@ : %@\n", urlPath, responseObject);
        [self processResponseObject:responseObject withResponseHandler:responseHandler];
    };
    
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error for %@ : %@\n", urlPath, error.localizedDescription);
        
        if (shouldNotifyError) {
            if ([self shouldPostErrorNotification]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkErrorNotification
                                                                    object:self
                                                                  userInfo:@{kNetworkErrorCodeKey:@(LSJURLResponseFailedByNetwork),
                                                                             kNetworkErrorMessageKey:error.localizedDescription}];
            }
        }
        
        if (responseHandler) {
            responseHandler(LSJURLResponseFailedByNetwork,error.localizedDescription);
        }
    };
    
    AFHTTPRequestOperation *requestOp;
    if (self.requestMethod == LSJURLGetRequest) {
        requestOp = [isStandBy?self.standbyRequestOpManager:self.requestOpManager GET:urlPath parameters:params success:success failure:failure];
    } else {
        requestOp = [isStandBy?self.standbyRequestOpManager:self.requestOpManager POST:urlPath parameters:params success:success failure:failure];
    }
    
    if (isStandBy) {
        self.standbyRequestOp = requestOp;
    } else {
        self.requestOp = requestOp;
    }
    return YES;
}

- (BOOL)requestURLPath:(NSString *)urlPath standbyURLPath:(NSString *)standbyUrlPath withParams:(NSDictionary *)params responseHandler:(LTURLResponseHandler)responseHandler {
    BOOL useStandbyRequest = standbyUrlPath.length > 0;
    BOOL success = [self requestURLPath:urlPath
                             withParams:params
                              isStandby:NO
                      shouldNotifyError:!useStandbyRequest
                        responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        if (useStandbyRequest && respStatus == LSJURLResponseFailedByNetwork) {
                            [self requestURLPath:standbyUrlPath withParams:params isStandby:YES shouldNotifyError:YES responseHandler:responseHandler];
                        } else {
                            if (responseHandler) {
                                responseHandler(respStatus,errorMessage);
                            }
                        }
                    }];
    return success;
}

-(BOOL)requestURLPath:(NSString *)urlPath withParams:(NSDictionary *)params responseHandler:(LTURLResponseHandler)responseHandler
{
    return [self requestURLPath:urlPath standbyURLPath:nil withParams:params responseHandler:responseHandler];
}

- (void)processResponseObject:(id)responseObject withResponseHandler:(LTURLResponseHandler)responseHandler {
    LSJURLResponseStatus status = LSJURLResponseNone;
    NSString *errorMessage;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if ([self.response isKindOfClass:[LSJURLResponse class]]) {
            LSJURLResponse *urlResp = self.response;
            [urlResp parseResponseWithDictionary:responseObject];
            
            status = urlResp.success.boolValue ? LSJURLResponseSuccess : LSJURLResponseFailedByInterface;
            errorMessage = (status == LSJURLResponseSuccess) ? nil : [NSString stringWithFormat:@"ResultCode: %@", urlResp.resultCode];
        } else {
            status = LSJURLResponseFailedByParsing;
            errorMessage = @"Parsing error: incorrect response class for JSON dictionary.\n";
        }
        
        if ([[self class] shouldPersistURLResponse]) {
            NSString *filePath = [[self class] persistenceFilePath];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (![((NSDictionary *)responseObject) writeToFile:filePath atomically:YES]) {
                    DLog(@"Persist response object fails!");
                }
            });
        }
    } else if ([responseObject isKindOfClass:[NSString class]]) {
        if ([self.response isKindOfClass:[NSString class]]) {
            self.response = responseObject;
            status = LSJURLResponseSuccess;
        } else {
            status = LSJURLResponseFailedByParsing;
            errorMessage = @"Parsing error: incorrect response class for JSON string.\n";
        }
    } else {
        errorMessage = @"Error data structure of response from interface!\n";
        status = LSJURLResponseFailedByInterface;
    }
    
    if (status != LSJURLResponseSuccess) {
        DLog(@"Error message : %@\n", errorMessage);
        
        if ([self shouldPostErrorNotification]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkErrorNotification
                                                                object:self
                                                              userInfo:@{kNetworkErrorCodeKey:@(status),
                                                                         kNetworkErrorMessageKey:errorMessage}];
        }
    }
    
    if (responseHandler) {
        responseHandler(status, errorMessage);
    }
    
}

@end
