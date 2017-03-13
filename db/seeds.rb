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
  skype: "echo123",
  skype_public: true,
  last_ip: "0.0.0.0",
  confirmed: true,
  last_seen: Time.utc(0).to_datetime,
  header_scroll: false
)
deleted_user.update_attribute(:ign, "Steve")

User.create!(
  uuid: "ae795aa86327408e92ab25c8a59f3ba1",
  ign: "jomo",
  email: "jomo@example.com",
  password: "123456789", # high seructity!
  password_confirmation: "123456789",
  role: Role.get(:superadmin),
  header_scroll: false
)
