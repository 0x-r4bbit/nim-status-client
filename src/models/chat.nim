import eventemitter, sets, json, strutils
import ../status/utils
import ../status/chat as status_chat
import chronicles
import ../status/libstatus

type
  ChatModel* = ref object
    events*: EventEmitter
    channels*: HashSet[string]

proc newChatModel*(events: EventEmitter): ChatModel =
  result = ChatModel()
  result.channels = initHashSet[string]()
  result.events = events

proc delete*(self: ChatModel) =
  discard

proc hasChannel*(self: ChatModel, chatId: string): bool =
  result = self.channels.contains(chatId)

proc join*(self: ChatModel, chatId: string) =
  if self.hasChannel(chatId): return

  self.channels.incl chatId

  # TODO move this
  let res = libstatus.addPeer("enode://44160e22e8b42bd32a06c1532165fa9e096eebedd7fa6d6e5f8bbef0440bc4a4591fe3651be68193a7ec029021cdb496cfe1d7f9f1dc69eb99226e6f39a7a5d4@35.225.221.245:443")
  debug "Add peer: ", response = res

  # TODO: save chat list in the db

  let oneToOne = isOneToOneChat(chatId)
  let filterResult = status_chat.loadFilters(chatId, oneToOne)
  debug "Filter result", res = filterResult
  status_chat.saveChat(chatId, oneToOne)
  status_chat.chatMessages(chatId)

  let parsedResult = parseJson(filterResult)["result"]
  var symKey = ""
  var topics = newSeq[string](0)
  for topicObj in parsedResult:
    if (($topicObj["chatId"]).strip(chars = {'"'}) == chatId):
      debug "Good chat ID", found = ($topicObj["chatId"]).strip(chars = {'"'}), wanted = chatId
      status_chat.addTopic(($(topicObj["chatId"])).strip(chars = {'"'}),($topicObj["topic"]).strip(chars = {'"'}), ($topicObj["filterId"]).strip(chars = {'"'}))
      topics.add(($topicObj["topic"]).strip(chars = {'"'}))
      symKey = ($topicObj["symKeyId"]).strip(chars = {'"'})
      debug "Got sym key", key = symKey

  if (symKey == ""):
    warn "No topic found for the chat. Cannot load past messages"
  else:
    debug "Topics", Topics = topics
    status_chat.addChatRequestRange(chatId)
    debug "Sym key", symKey = symKey
    status_chat.requestMessages(topics, symKey)
    status_chat.chatMessages(chatId)
    # status_chat.addTopic(chatId, $chatTopic["topic"], $chatTopic["filterId"])
