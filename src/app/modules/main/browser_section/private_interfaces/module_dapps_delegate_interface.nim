method dappsDidLoad*(self: AccessInterface) {.base.} =
  raise newException(ValueError, "No implementation available")