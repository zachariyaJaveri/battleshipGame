//
//  Client.swift
//  Battleship
//
//  Created by Sandy on 2019-04-01.
//  Copyright © 2019 Sandy. All rights reserved.
//
// https://stackoverflow.com/questions/11940911/ios-socket-networking-fundamentals-using-cfstreamcreatepairwithsockettohost
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Streams/Articles/PollingVersusRunloop.html#//apple_ref/doc/uid/20002275-CJBEDDBG
// https://developer.apple.com/documentation/corefoundation/1539739-cfstreamcreatepairwithsockettoho?language=objc

import Foundation


// =====================================================
// all code required to connect and get/send data to server
// =====================================================
class Client:NSObject, StreamDelegate {
    
    // --------------------------------------------------------
    // define level of printing of debug messages
    // --------------------------------------------------------
    let debug = false
    private func debug(_ str:String) {
        if debug {
            print ("Client: \(str)")
        }
    }
    
    // --------------------------------------------------------
    // global vars
    // --------------------------------------------------------
    var listenerDelegate:ClientServerListenerDelegate?
    var connectionDelegate:ClientConnectionDelegate?
    var username:String?
    
    private var isWritable:Bool = false
    private let maxLength = 4096;
    
    // --------------------------------------------------------
    // these are the streams to read and write from the socket
    // --------------------------------------------------------
    private var inputStream:InputStream?
    private var outputStream:OutputStream?
    
    // --------------------------------------------------------
    // connect to host, and setup up input and output sockets
    // --------------------------------------------------------
    func connect(toURL host:String, viaPort port:Int, as username:String) {
        self.username = username
        let CFhost:CFString = host as CFString
        let CFport = UInt32(port)
        
        // if I understand correctly, and I may be wrong,
        // but CF... is actually C-code, and as such is not part
        // of the ARC memory managed code, hence the Unmanaged<T>
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        // this code will create two sockets, one for reading,
        // and one for writing.
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, CFhost, CFport, &readStream, &writeStream)
        
        // because readStream and writeStream are "unmanaged", we
        // want swift to take care of the memory, hence the "takeRetainedValue()"
        // NOTE: not quite sure about this
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        // we need to set ourselves as the delegate for the input
        // stream, so we can capture input as it arrives
        inputStream?.delegate = self
        outputStream?.delegate = self
        
        // schedule the checking for input and output data
        // in the current runLoop, common events
        inputStream!.schedule(in: .current, forMode: RunLoop.Mode.common)
        outputStream!.schedule(in: .current, forMode: RunLoop.Mode.common)
        
        // since the streams are connected to "files", we need to open
        // them, which essentially creates the sockets
        inputStream!.open()
        outputStream!.open()
        
        // just debugging info
        debug ("openned sockets")
    }
    
    // --------------------------------------------------------
    // responding to stream events ()
    // NB: Since we are the stream delegate, the code for the
    //     "stream" object calls this function when a stream
    //     "event" happens
    // --------------------------------------------------------
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
            
        // ready for business
        case .openCompleted:
            debug ("We have successfully opened a socket")
            
        // read stream has data available for reading
        case .hasBytesAvailable:
            readAndProcessData(from:aStream)
            
        // no more talking to or listening to the socket :(
        case .endEncountered:
            print("CLIENT: socket closed")
            closeSocket()
            
        // somebody is not happy
        case .errorOccurred:
            print("CLIENT: error occurred")
            let str = aStream.streamError?.localizedDescription ?? "unknown error"
            listenerDelegate?.clientListenerReceived(errorString: str)
            connectionDelegate?.clientReceived(errorString: str)
            closeSocket()
            
            // the write stream is available for writing to
            // NB: this event is triggered after every write as been
        //     completed
        case .hasSpaceAvailable:
            debug ("have space available")
            isWritable = true
            sendOutputQueue()
            
        // wtf?
        default:
            debug ("some stream event...")
            break
        }
    }
    
    // --------------------------------------------------------
    // read and process data
    // --------------------------------------------------------
    private func readAndProcessData(from aStream:Stream) {
        let allData = readFrom(inputStream: aStream as! InputStream)
        
        // assume that messages do not contain carriage returns, and
        // if there are, then it is simply two messages mushed together
        for part in allData.split(separator:"\n") {
            
            let data = String(part)
            print ("CLIENT READ: \(data)")
            let receivedData = ClientReceivedData(rawData:data)
            
            // the server wants to know our name, we are not
            // properly connected until she knows who we are.
            // ... so send our name, I hope she likes us
            if receivedData.dataType == .serverNameVerification {
                let name = username ?? "client unknown user"
                connectionDelegate?.clientConnectionInProgress(asPlayer: receivedData.player, andName: name)
                addToOutputQueue(thisData: name)
            }
            
            // the server accepts our name, and we are now
            // officially connected, call the delegate code
            // to celebrate our union
            if receivedData.dataType == .connectionYouConnected {
                debug("you connected")
                connectionDelegate?.clientDidConnect(asPlayer: receivedData.player, andName: receivedData.username)
                listenerDelegate?.clientListenerDidConnect(asPlayer: receivedData.player, andName: receivedData.username)
            }
            
            // the server is not happy, and wants a divorce
            // call the delegate's divorce lawyer, our relationship
            // has ended
            if receivedData.dataType == .connectionOrListenerError {
                listenerDelegate?.clientListenerReceived(errorString: receivedData.userData)
                connectionDelegate?.clientReceived(errorString: receivedData.userData)
                closeSocket()
            }
            
            // finally, what was this all about?  send the
            // raw data to the delegate, so that he can decipher
            // what to do next
            listenerDelegate?.clientListenerReceived(rawData: data)
        }
    }
    
    // --------------------------------------------------------
    // reading from stream
    // --------------------------------------------------------
    private func readFrom(inputStream stream:InputStream)->String {
        
        // define the buffer memory, and pointer to buffer
        let bufferPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxLength)
        
        var rawData = ""
        
        // if there is data to read..
        while stream.hasBytesAvailable {
            
            // put the data int bufferPointer, creating a c-string
            let bytesRead = stream.read(bufferPointer, maxLength: maxLength)
            
            // we have successfully read data
            if bytesRead > 0 {
                
                // convert the c-string data from the buffer into a string, and
                // free the memory when done
                rawData += String(bytesNoCopy: bufferPointer, length: bytesRead, encoding: .utf8, freeWhenDone: true) ?? "unknown:unknown:"
                return rawData
            }
            
            // there was an error!!!
            let _ = stream.streamError
            
            // release the buffer memory
            bufferPointer.deallocate()
            
        }
        return ""
    }
    
    // --------------------------------------------------------
    // send data to server
    // --------------------------------------------------------
    private func sendToServer(dataString: String) {
        let name = username ?? "?"
        print ("CLIENT SENT: \(name):\(dataString)")
        let newDataString = dataString +  "\n"
        let strData = newDataString.data(using: .utf8) ?? "invalid text\n".data(using: .utf8)!
        
        _ = strData.withUnsafeBytes{
            outputStream?.write($0, maxLength: strData.count)
        }
    }
    
    // --------------------------------------------------------
    // closing both sockets
    // --------------------------------------------------------
    func closeSocket() {
        connectionDelegate?.clientDisconnected()
        inputStream?.close()
        outputStream?.close()
    }
    
    
    // -------------------------------------------------
    // output queue
    // -------------------------------------------------
    var outputQueue = [String]()
    
    func addToOutputQueue(thisData str:String) {
        outputQueue.append(str)
        sendOutputQueue()
    }
    
    // send one message from output queue to the server
    private func sendOutputQueue() {
        debug ("outputQueue, is writable? \(isWritable) \(outputQueue.count)")
        if isWritable {
            if outputQueue.count > 0 {
                let toSend = outputQueue.first!
                outputQueue.remove(at: 0)
                
                // set this to false, once the data has been
                // sent, the a stream event will occur, and we
                // will reset it to true
                isWritable = false
                
                // send the data already!
                sendToServer(dataString: toSend)
            }
        }
    }
}
