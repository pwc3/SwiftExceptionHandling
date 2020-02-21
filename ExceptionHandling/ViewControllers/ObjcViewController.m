//
//  ObjcViewController.m
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

#import "ObjcViewController.h"

#import "ObjcData.h"
#import "ObjcErrorRaisingOperation.h"
#import "ObjcExceptionThrowingOperation.h"
#import "ObjcOperation.h"

@interface ObjcViewController ()

@end

@implementation ObjcViewController

- (IBAction)handledError:(id)sender
{
    ObjcErrorRaisingOperation *op = [[ObjcErrorRaisingOperation alloc] initWithForbiddenValue:@"foobar"];
    NSError *error = nil;

    ObjcData *result = [op performOperationWithValue:@"foobar" error:&error];
    if (!result)
    {
        NSLog(@"An error occurred: %@", error);
        [self reportError:error];
        return;
    }

    NSLog(@"Received ObjcData<%p> value=%@", result, result.value);
}

- (IBAction)handledException:(id)sender
{
    @try
    {
        ObjcExceptionThrowingOperation *op = [[ObjcExceptionThrowingOperation alloc] initWithForbiddenValue:@"foobar"];
        ObjcData *result = [op performOperationWithValue:@"foobar"];
        NSLog(@"Received ObjcData<%p> value=%@", result, result.value);
    }
    @catch (NSException *ex)
    {
        NSLog(@"An exception was caught: %@", ex);
        [self reportErrorMessage:ex.reason];
    }
}

- (IBAction)unhandledException:(id)sender
{
    ObjcExceptionThrowingOperation *op = [[ObjcExceptionThrowingOperation alloc] initWithForbiddenValue:@"foobar"];
    ObjcData *result = [op performOperationWithValue:@"foobar"];
    NSLog(@"Received ObjcData<%p> value=%@", result, result.value);
}

- (void)reportError:(NSError *)error
{
    [self reportErrorMessage:error.localizedDescription];
}

- (void)reportErrorMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
