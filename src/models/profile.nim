import eventemitter

type Profile* = ref object
    username*, identicon*: string

proc toProfileModel*(obj: object): Profile =
    result = Profile(username: obj.name, identicon: obj.photoPath)

# proc newProfileModel*(): ProfileModel =
    # result = ProfileModel()
