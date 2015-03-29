//
//  Geocoder.m
//  Snooke
//  根据百度提供API解析经纬度。获得地址，城市代码等.
//  Created by AsOne on 13-4-7.
//  Copyright (c) 2013年 AsOne. All rights reserved.
//

#import "BDGeocoder.h"
#import <MapKit/MapKit.h>

#define kSVGeocoderTimeoutInterval 20

enum {
    GeocoderStateReady = 0,
    GeocoderStateExecuting,
    GeocoderStateFinished
};

typedef NSUInteger GeocoderState;


@interface NSString (URLEncoding)
- (NSString*)encodedURLParameterString;
@end


@interface BDGeocoder ()

@property (nonatomic, strong) NSMutableURLRequest *operationRequest;
@property (nonatomic, strong) NSMutableData *operationData;
@property (nonatomic, strong) NSURLConnection *operationConnection;
@property (nonatomic, strong) NSHTTPURLResponse *operationURLResponse;

@property (nonatomic, copy) BDGeocoderCompletionHandler operationCompletionBlock;
@property (nonatomic, readwrite) GeocoderState state;
@property (nonatomic, strong) NSString *requestPath;
@property (nonatomic, strong) NSTimer *timeoutTimer;

- (BDGeocoder*)initWithParameters:(NSMutableDictionary*)parameters completion:(BDGeocoderCompletionHandler)block;

- (void)addParametersToRequest:(NSMutableDictionary*)parameters;
- (void)finish;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)callCompletionBlockWithResponse:(id)response error:(NSError *)error;

@end

@implementation BDGeocoder
// private properties
@synthesize operationRequest, operationData, operationConnection, operationURLResponse, state;
@synthesize operationCompletionBlock, timeoutTimer;

#pragma mark -

- (void)dealloc {
    [operationConnection cancel];
    [super dealloc];
}

#pragma mark - Convenience Initializers


+ (BDGeocoder *)reverseGeocode:(CLLocationCoordinate2D)coordinate completion:(BDGeocoderCompletionHandler)block {
    BDGeocoder *geocoder = [[[self alloc] initWithCoordinate:coordinate completion:block] autorelease];
    [geocoder start];
    return geocoder;
}

#pragma mark - Public Initializers

- (BDGeocoder*)initWithCoordinate:(CLLocationCoordinate2D)coordinate completion:(BDGeocoderCompletionHandler)block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude], @"location", nil];
    
    return [self initWithParameters:parameters completion:block];
}


#pragma mark - Private Utility Methods

- (BDGeocoder*)initWithParameters:(NSMutableDictionary*)parameters completion:(BDGeocoderCompletionHandler)block {
    self = [super init];
    self.operationCompletionBlock = block;
    self.operationRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.map.baidu.com/geocoder"]];
    [self.operationRequest setTimeoutInterval:kSVGeocoderTimeoutInterval];
    
    [parameters setValue:@"json" forKey:@"output"];
    [parameters setValue:BAIDU_API_KEY forKey:@"key"];
    [self addParametersToRequest:parameters];
    
    self.state = GeocoderStateReady;
    
    return self;
}

- (void)addParametersToRequest:(NSMutableDictionary*)parameters {
    
    NSMutableArray *paramStringsArray = [NSMutableArray arrayWithCapacity:[[parameters allKeys] count]];
    
    for(NSString *key in [parameters allKeys]) {
        NSObject *paramValue = [parameters valueForKey:key];
		if ([paramValue isKindOfClass:[NSString class]]) {
			[paramStringsArray addObject:[NSString stringWithFormat:@"%@=%@", key, [(NSString *)paramValue encodedURLParameterString]]];
		} else {
			[paramStringsArray addObject:[NSString stringWithFormat:@"%@=%@", key, paramValue]];
		}
    }
    
    NSString *paramsString = [paramStringsArray componentsJoinedByString:@"&"];
    NSString *baseAddress = self.operationRequest.URL.absoluteString;
    baseAddress = [baseAddress stringByAppendingFormat:@"?%@", paramsString];
    [self.operationRequest setURL:[NSURL URLWithString:baseAddress]];
}

- (void)setTimeoutTimer:(NSTimer *)newTimer {
    
    if(timeoutTimer)
        [timeoutTimer invalidate], timeoutTimer = nil;
    
    if(newTimer)
        timeoutTimer = newTimer;
}

#pragma mark - NSOperation methods

- (void)start {
    
    if(self.isCancelled) {
        [self finish];
        return;
    }
    
    if(![NSThread isMainThread]) { // NSOperationQueue calls start from a bg thread (through GCD), but NSURLConnection already does that by itself
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    self.state = GeocoderStateExecuting;
    [self didChangeValueForKey:@"isExecuting"];
    
    operationData = [[NSMutableData alloc] init];
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:kSVGeocoderTimeoutInterval target:self selector:@selector(requestTimeout) userInfo:nil repeats:NO];
    
    operationConnection = [[NSURLConnection alloc] initWithRequest:self.operationRequest delegate:self startImmediately:NO];
    [self.operationConnection start];
    
#if !(defined SVHTTPREQUEST_DISABLE_LOGGING)
    NSLog(@"[%@] %@", self.operationRequest.HTTPMethod, self.operationRequest.URL.absoluteString);
#endif
}

- (void)finish {
    [self.operationConnection cancel];
    operationConnection = nil;
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.state = GeocoderStateFinished;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)cancel {
    if([self isFinished])
        return;
    
    [super cancel];
    [self callCompletionBlockWithResponse:nil error:nil];
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isFinished {
    return self.state == GeocoderStateFinished;
}

- (BOOL)isExecuting {
    return self.state == GeocoderStateExecuting;
}

- (GeocoderState)state {
    @synchronized(self) {
        return state;
    }
}

- (void)setState:(GeocoderState)newState {
    @synchronized(self) {
        [self willChangeValueForKey:@"state"];
        state = newState;
        [self didChangeValueForKey:@"state"];
    }
}


#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)requestTimeout {
    NSURL *failingURL = self.operationRequest.URL;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"The operation timed out.", NSLocalizedDescriptionKey,
                              failingURL, NSURLErrorFailingURLErrorKey,
                              failingURL.absoluteString, NSURLErrorFailingURLStringErrorKey, nil];
    
    NSError *timeoutError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:userInfo];
    [self connection:nil didFailWithError:timeoutError];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.operationURLResponse = (NSHTTPURLResponse*)response;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.operationData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    BDPlacemark *placemark = nil;
    NSError *error = nil;
    //TODO change it.
    if ([[operationURLResponse MIMEType] isEqualToString:@"text/javascript"]) {
        if(self.operationData && self.operationData.length > 0) {
            id response = [NSData dataWithData:self.operationData];
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            NSDictionary *result = [jsonObject objectForKey:@"result"];
            NSString *status = [jsonObject valueForKey:@"status"];
            if( [status isEqualToString:@"OK"]){
                placemark = [[BDPlacemark alloc] initWithDictionary:result];
            }
        }
    }
    
    [self callCompletionBlockWithResponse:placemark error:error];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self callCompletionBlockWithResponse:nil error:error];
}

- (void)callCompletionBlockWithResponse:(id)response error:(NSError *)error {
    self.timeoutTimer = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *serverError = error;
        
        if(!serverError && self.operationURLResponse.statusCode == 500) {
            serverError = [NSError errorWithDomain:NSURLErrorDomain
                                              code:NSURLErrorBadServerResponse
                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    @"Bad Server Response.", NSLocalizedDescriptionKey,
                                                    self.operationRequest.URL, NSURLErrorFailingURLErrorKey,
                                                    self.operationRequest.URL.absoluteString, NSURLErrorFailingURLStringErrorKey, nil]];
        }
        
        if(self.operationCompletionBlock && !self.isCancelled)
            self.operationCompletionBlock([response copy], self.operationURLResponse, serverError);
        
        [self finish];
    });
}


@end


#pragma mark -

@implementation NSString (URLEncoding)

- (NSString*)encodedURLParameterString {
    NSString *result = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                            ( CFStringRef)self,
                                                                                            NULL,
                                                                                            CFSTR(":/=,!$&'()*+;[]@#?|"),
                                                                                            kCFStringEncodingUTF8));
	return result;
}

@end
