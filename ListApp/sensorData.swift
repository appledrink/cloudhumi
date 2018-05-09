//
//  Sensordata.swift
//  ListApp
//
//  Created by MacbookUNI on 23.11.17.
//  Copyright © 2017 MacbookUNI. All rights reserved.
//

import Foundation
import UIKit


// Definition View-Übergreifender Variablen
struct MyVariables {
    static var IPAdress = String()
    static var Temperatur = String()
    static var Humi = String()
    var temperatur_wert = String()
    var feuchtigkeit_wert = String ()
    
}





class sensorData: NSObject {
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    
    let maxReadLength = 1024
    
    
    
    func Connect() {
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           MyVariables.IPAdress as CFString,
                                           88,
                                           &readStream,
                                           &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        outputStream.delegate = self
        
        inputStream.schedule(in: .main, forMode: .commonModes)
        outputStream.schedule(in: .main, forMode: .commonModes)
        
        inputStream.open()
        outputStream.open()
    }
    
    func sendAnfrage (){
        let data = "Humidity".data(using: .ascii)!
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength:data.count) }
    }
    
    func Humidity() {
        Connect()
        sendAnfrage()
    }
    
}


extension sensorData: StreamDelegate{
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            print("new Values received")
            readReceivedBytes(stream: aStream as! InputStream)
            // case Stream.Event.endEncountered:
        // stopChatSession()
        case Stream.Event.errorOccurred:
            print("error occurred")
        case Stream.Event.hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
            break
        }
    }
    
    
    private func readReceivedBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
            
            print("numberOfBytesRead:", numberOfBytesRead)
            print("buffer: ", buffer)
            
            _ = processedMessageString(buffer: buffer, length: numberOfBytesRead)
            
            
            if numberOfBytesRead < 0 {
                if let _ = inputStream.streamError {
                    break
                }
            }
            
        }
        
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
                                        length: Int) -> MyVariables? {
        
        guard let werteAsString = String(bytesNoCopy: buffer,
                                         length: length,
                                         encoding: .ascii,
                                         freeWhenDone: true)?.components(separatedBy: "/"),
            let temperatur_wert = werteAsString.first,
            let feuchtigkeit_wert = werteAsString.last else {
                return nil
        }
        
        print("temperatur_wert: ",temperatur_wert)
        print("feuchtigkeit_wert: ", feuchtigkeit_wert)
        
        //let messageSender:MessageSender = (name == self.username) ? .ourself : .someoneElse
        
        MyVariables.Temperatur = temperatur_wert
        MyVariables.Humi = feuchtigkeit_wert
        
        
        //return MyVariables(temperatur_wert: temperatur_wert, feuchtigkeit_wert: feuchtigkeit_wert)
        return MyVariables(temperatur_wert: temperatur_wert, feuchtigkeit_wert: feuchtigkeit_wert)
        
    }
    
}


