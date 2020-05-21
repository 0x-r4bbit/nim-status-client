import libstatus
import json
import utils
import times
import strutils

proc startMessenger*() =
  let payload = %* {
    "jsonrpc": "2.0",
    "id": 3, #TODO:
    "method": "startMessenger".prefix,
    "params": []
  }
  discard $libstatus.callPrivateRPC($payload)
  # TODO: create template for error handling

proc loadFilters*(chatId: string, oneToOne = false): string =
  let payload = %* {
    "jsonrpc": "2.0",
    "id": 3, #TODO:
    "method": "loadFilters".prefix,
    "params": [
      [{
        "ChatID": chatId,
        "OneToOne": oneToOne
      }]
    ]
  }
  $libstatus.callPrivateRPC($payload)

proc saveChat*(chatId: string, oneToOne = false) =
  let payload = %* {
    "jsonrpc": "2.0",
    "id": 4,
    "method": "saveChat".prefix,
    "params": [ #TODO: determine where do these values come from
      {
        "lastClockValue": 0,
        "color": "#51d0f0",
        "name": chatId,
        "lastMessage": nil,
        "active": true,
        "id": chatId,
        "unviewedMessagesCount": 0,
        "chatType":  if oneToOne: 1 else: 2,
        "timestamp": 1588940692659
      }
    ]
  }
  discard $libstatus.callPrivateRPC($payload)

proc chatMessages*(chatId: string) =
  let payload = %* {
    "jsonrpc": "2.0",
    "id": 3, #TODO:
    "method": "chatMessages".prefix,
    "params": [
      chatId, nil, 20
    ]
  }
  discard $libstatus.callPrivateRPC($payload)
  # TODO: create template for error handling
  discard $libstatus.callPrivateRPC($payload)

# TODO move this somewhere else
proc addChatRequestRange*(chatId: string) =
  let payload = %* {
    "jsonrpc":"2.0",
    "id": 7,
    "method":"mailservers_addChatRequestRange",
    "params": [
      {
        "chat-id": chatId,
        "highest-request-to": times.toUnix(times.getTime()),
        "lowest-request-from": times.toUnix(times.getTime()) - 86400
      }
    ]
  }
  let t = $libstatus.callPrivateRPC($payload)
  echo "Added request ", t

proc requestMessages*(topics: seq[string], symKeyID: string) =
  let payload = %* {
   "jsonrpc":"2.0",
   "id": 8,
   "method":"requestMessages".prefix,
   "params":[
      {
         "topics": topics,
           #[ [
            # topic.strip(chars = {'"'}) # Enable multiple topics to be requested?
            "0x257f7afa",
            "0x5c32bfbd",
            "0x9c22ff5f",
            "0xa19c4b6a",
            "0xc0e88081"
         ],]# 
         # TODO unhardcode
         "mailServerPeer": "enode://44160e22e8b42bd32a06c1532165fa9e096eebedd7fa6d6e5f8bbef0440bc4a4591fe3651be68193a7ec029021cdb496cfe1d7f9f1dc69eb99226e6f39a7a5d4@35.225.221.245:443",
         "symKeyID": symKeyID,
         "timeout": 30,
         "limit": 1000, # TODO unhardcode this later
         "cursor": nil,
         "from": times.toUnix(times.getTime()) - 86400
      }
    ]
  }
  let res = $libstatus.callPrivateRPC($payload)
  echo "Result ", $res

proc addTopic*(chatId: string, topic: string, filterId: string) =
  let payload = %* {
    "jsonrpc":"2.0",
    "id":9,
    "method":"mailservers_addMailserverTopic",
    "params":[
      {
        "topic": topic,
        "discovery?":false,
        "negotiated?":false,
        "chat-ids":[chatId],
        "last-request":times.toUnix(times.getTime()),
        "filter-ids":[filterId.strip(chars = {'"'})]
      }
    ]
  }
  let res = $libstatus.callPrivateRPC($payload)
  echo "ADD TOPIC ", $res


proc sendChatMessage*(chatId: string, msg: string): string =
  let payload = %* {
    "jsonrpc": "2.0",
    "id": 40,
    "method": "sendChatMessage".prefix,
    "params": [
      {
        "chatId": chatId,
        "text": msg,
        "responseTo": nil,
        "ensName": nil,
        "sticker": nil,
        "contentType": 1
      }
    ]
  }
  $libstatus.callPrivateRPC($payload)
