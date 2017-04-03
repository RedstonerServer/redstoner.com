# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Role.create!([
  {name: "disabled", value: 1, color: "#ccc"},
  {name: "banned", value: 2, color: "#ccc"},
  {name: "normal", value: 10, color: "#282"},
  {name: "mod", value: 100, color: "#6af"},
  {name: "admin", value: 200, color: "#d22"},
  {name: "superadmin", value: 500, color: "#d22"}
])

Badge.create!([
  {name: "none", symbol: "", value: 0, color: "#000"},
  {name: "donor", symbol: "$", value: 1, color: "#f60"},
  {name: "developer", symbol: "D", value: 2, color: "#a0a"},
  {name: "retired", symbol: "R", value: 10, color: "#0aa"},
  {name: "lead", symbol: "L", value: 100, color: "#a00"}
])

userpw = SecureRandom.hex(36)


# fallback profile for deleted users
deleted_user = User.create!(
  uuid: "8667ba71b85a4004af54457a9734eed7",
  name: "Deleted user",
  email: "redstonerserver@gmail.com",
  ign: "Notch", # just need any valid ign here, overriding later
  about: "Hey, apparently, I do no longer exist. This is just a placeholder profile",
  password: userpw,
  password_confirmation: userpw,
  role: Role.get(:disabled),
  badge: Badge.get(:none),
  skype: "echo123",
  skype_public: true,
  last_ip: "0.0.0.0",
  confirmed: true,
  last_seen: Time.utc(0).to_datetime
)
deleted_user.update_attribute(:ign, "Steve")

User.create!(
  uuid: "ae795aa86327408e92ab25c8a59f3ba1",
  ign: "jomo",
  email: "jomo@example.com",
  password: "123456789", # high seructity!
  password_confirmation: "123456789",
  role: Role.get(:superadmin),
  badge: Badge.get(:donor),
  confirmed: true
)
User.create!(
  uuid: "7f52491ab5d64c11b4a43806db47a101",
  ign: "YummyRedstone",
  email: "yummy@example.com",
  password: "123456789", # high seructity!
  password_confirmation: "123456789",
  role: Role.get(:admin),
  badge: Badge.get(:lead),
  confirmed: true
)
User.create!(
  uuid: "d2693e9193e14e3f929ff38e1ce8df03",
  ign: "Pepich1851",
  email: "pepe@example.com",
  password: "123456789", # high seructity!
  password_confirmation: "123456789",
  role: Role.get(:superadmin),
  badge: Badge.get(:retired),
  confirmed: true
)
User.create!(
  uuid: "c69f8316c60a4f8ca922bda933e01acd",
  ign: "Doomblah",
  email: "doom@example.com",
  password: "123456789", # high seructity!
  password_confirmation: "123456789",
  role: Role.get(:normal),
  badge: Badge.get(:developer),
  confirmed: true
)
User.create!(
  uuid: "b85a91b558b0474da2a42d5dd025f9e5",
  ign: "Futsy",
  email: "futsy@example.com",
  password: "123456789", # high seructity!
  password_confirmation: "123456789",
  role: Role.get(:mod),
  badge: Badge.get(:none),
  confirmed: true
)
