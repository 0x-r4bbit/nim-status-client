import NimQml
import json, sets, eventemitter
import strutils
import ../../status/chat as status_chat
import view
import messages
import ../signals/types
import ../../models/chat

var sendMessage = proc (view: ChatsView, chatId: string, msg: string): string =
  echo "sending public message!"
  var sentMessage = status_chat.sendChatMessage(chatId, msg)
  var parsedMessage = parseJson(sentMessage)["result"]["chats"][0]["lastMessage"]

  let chatMessage = newChatMessage()
  chatMessage.userName = parsedMessage["alias"].str
  chatMessage.message = msg
  chatMessage.timestamp = $parsedMessage["timestamp"]
  chatMessage.identicon = parsedMessage["identicon"].str
  chatMessage.isCurrentUser = true

  view.pushMessage(chatId, chatMessage)
  sentMessage

type ChatController* = ref object of SignalSubscriber
  view*: ChatsView
  model*: ChatModel
  variant*: QVariant

proc newController*(events: EventEmitter): ChatController =
  result = ChatController()
  result.model = newChatModel(events)
  result.view = newChatsView(result.model, sendMessage)
  result.variant = newQVariant(result.view)

proc delete*(self: ChatController) =
  delete self.view
  delete self.variant

proc init*(self: ChatController) =
  discard

proc load*(self: ChatController, chatId: string) =
  # TODO: we need a function to load the channels from the db.
  #       and... called from init() instead from nim_status_client
  discard self.view.joinChat(chatId)
  self.view.setActiveChannelByIndex(0)

proc join*(self: ChatController, chatId: string) =
  # TODO: check whether we have joined a chat already or not
  # TODO: save chat list in the db
  echo "Joining chat: ", chatId
  let oneToOne = isOneToOneChat(chatId)
  echo "Is one to one? ", oneToOne
  let filterResult = status_chat.loadFilters(chatId, oneToOne)
  status_chat.saveChat(chatId, oneToOne)
  status_chat.chatMessages(chatId)


  let parsedResult = parseJson(filterResult)["result"]
  var symKey = ""
  var topics = newSeq[string](0)
  for topicObj in parsedResult:
    topics.add(($topicObj["topic"]).strip(chars = {'"'}))
    status_chat.addTopic(($(topicObj["chatId"])).strip(chars = {'"'}),($topicObj["topic"]).strip(chars = {'"'}), ($topicObj["filterId"]).strip(chars = {'"'}))
    if (($topicObj["chatId"]).strip(chars = {'"'}) == chatId):
      symKey = ($topicObj["symKeyId"]).strip(chars = {'"'})

  if (symKey == ""):
    echo "No topic found for the chat. Cannot load past messages"
  else:
    echo "TOpics ", topics
    status_chat.requestMessages(topics, symKey)
    status_chat.addChatRequestRange(chatId)
    # status_chat.addTopic(chatId, $chatTopic["topic"], $chatTopic["filterId"])


  # self.chatsModel.addNameTolist(channel.name)
  self.view.addNameTolist(chatId)

method onSignal(self: ChatController, data: Signal) =
  var chatSignal = cast[ChatSignal](data)
  for message in chatSignal.messages:
    let chatMessage = newChatMessage()
    chatMessage.userName = message.alias
    chatMessage.message = message.text
    chatMessage.timestamp = message.timestamp #TODO convert to date/time?
    chatMessage.identicon = message.identicon
    chatMessage.isCurrentUser = message.isCurrentUser
    self.view.pushMessage(message.chatId, chatMessage)
