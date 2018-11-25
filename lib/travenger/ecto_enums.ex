import EctoEnum

defenum(
  GenderTypeEnum,
  male: 0,
  female: 1
)

defenum(
  UserRoleEnum,
  creator: 0,
  admin: 1,
  member: 2,
  waiting: 3
)

defenum(
  MembershipStatusEnum,
  pending: 0,
  approved: 1,
  invited: 2,
  accepted: 3,
  banned: 4,
  unbanned: 5,
  removed: 6
)

defenum(
  InvitationStatusEnum,
  pending: 0,
  declined: 1,
  accepted: 2,
  cancelled: 3
)

defenum(
  InvitationTypeEnum,
  group: 0,
  event: 1
)

defenum(
  EntityActionEnum,
  create: 0,
  update: 1,
  delete: 2,
  send: 3,
  comment: 4
)

defenum(
  ObjectTypeEnum,
  group: 0,
  post: 1,
  user: 2
)
