//
//  SwiftViewController.swift
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

import UIKit

class SwiftViewController: UITableViewController {

    @IBAction func handledError(_ sender: Any) {
        do {
            let op = ObjcErrorRaisingOperation(forbiddenValue: "foobar")
            let data = try op.perform(withValue: "foobar")

            NSLog("Received ObjcData<%p> value=%@", data, data.value)
        }
        catch {
            NSLog("An error occurred: \(error)")
            report(error)
        }
    }

    @IBAction func handledException(_ sender: Any) {
        do {
            let data = try ObjcExceptionHandler.typedResult { () -> ObjcData in
                // This creates a new object.
                let op = ObjcExceptionThrowingOperation(forbiddenValue: "foobar")

                // This raises an exception that abnormally exits this scope before `op` is released. This causes a memory leak.
                return op.perform(withValue: "foobar")

                // If no exception is raised, `op` will be released (and deallocated) here as it goes out of scope.
            }
            NSLog("Received ObjcData<%p> value=%@", data, data.value)
        }
        catch {
            NSLog("An error occurred: \(error)")
            report(error)
        }
    }

    @IBAction func handledSwiftError(_ sender: Any) {
        do {
            let op = SwiftErrorRaisingOperation(forbiddenValue: "foobar")
            let data = try op.perform(withValue: "foobar")

            NSLog("Received ObjcData<%p> value=%@", data, data.value)
        }
        catch {
            NSLog("An error occurred: \(error)")
            report(error)
        }
    }

    @IBAction func unhandledException(_ sender: Any) {
        let op = ObjcExceptionThrowingOperation(forbiddenValue: "foobar")
        op.perform(withValue: "foobar")
    }

    private func report(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
