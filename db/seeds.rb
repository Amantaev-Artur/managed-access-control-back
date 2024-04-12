# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

main_user = User.create(
  email: 'aa@aa.ru',
  password: 'qwerty123',
  name: 'Art A',
  nickname: 'Art'
)

user_1 = User.create(
  email: 'bb@bb.ru',
  password: 'asdfgh',
  name: 'Other U1',
  nickname: 'HAHA'
)

user_2 = User.create(
  email: 'cc@cc.ru',
  password: 'zxcvbn',
  name: 'Other U2',
  nickname: 'QAQA'
)

main_group = Group.create(
  author: main_user,
  users: [main_user, user_1, user_2],
  name: 'Main group',
  description: 'This is main group'
)

sub_group = Group.create(
  author: main_user,
  users: [main_user, user_1],
  name: 'back',
  description: 'This is for backend developers',
  parent: main_group
)

priv_group = Group.create(
  author: user_1,
  users: [user_1],
  name: 'Secret',
  description: 'My secret group',
  parent: sub_group
)

login_access_type = AccessType.create(
  slug: 'login'
)

base_access = Access.create(
  access_type: login_access_type,
  data: {
    login: 'aa@aa.ru',
    password: 'aaaa'
  },
  size: 'small',
  author: main_user,
  groups: [main_group]
)

private_access = Access.create(
  access_type: login_access_type,
  data: {
    login: 'aa',
    password: 'bb'
  },
  size: 'small',
  author: user_1,
  groups: [priv_group]
)
