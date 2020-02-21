//
//  ObjcErrorRaisingOperation.m
//  ExceptionHandling
//
//  Copyright (c) 2020 Rocket Insights, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "ObjcErrorRaisingOperation.h"

#import "ObjcData.h"
#import "ObjcOperationError.h"

@implementation ObjcErrorRaisingOperation

- (nullable ObjcData *)performOperationWithValue:(NSString *)value error:(NSError **)error
{
    // We (unnecessarily) allocate the result here instead of after the if-block below.
    ObjcData *result = [[ObjcData alloc] initWithValue:value];

    if ([value isEqualToString:self.forbiddenValue])
    {
        if (error)
        {
            *error = ObjcOperationCreateError(ObjcOperationErrorCodeInvalidInput, [self errorMessage]);
        }

        // Since the function exits normally via a `return`, `result` is released as it goes out of scope.
        return nil;
    }

    // The return value is autoreleased, meaning the caller must retain it or it will be released the next time the autorelease pool drains.
    return result;
}

@end
