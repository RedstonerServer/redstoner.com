# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Role.create!([
  {name: "disabled", value: 1},
  {name: "banned", value: 2},
  {name: "unconfirmed", value: 5},
  {name: "default", value: 10},
  {name: "donor", value: 40},
  {name: "mod", value: 100},
  {name: "admin", value: 200},
  {name: "superadmin", value: 500}
])

userpw = SecureRandom.hex(64)

deleted_user = User.create!(
  name: "Deleted user",
  email: "redstonerserver@gmail.com",
  ign: "Mojang",
  about: "Hey, apparently, I do no longer exist. This is just a placeholder profile",
  password: userpw,
  password_confirmation: userpw,
  role: Role.get(:disabled),
  confirm_code: SecureRandom.hex(16),
  skype: "echo123",
  skype_public: true,
  last_ip: "0.0.0.0",
  last_login: Time.utc(0).to_datetime
  )
  deleted_user.update_attribute(:ign, "Steve")

User.create!(
  name: "Redstone Sheep",
  ign: "redstone_sheep",
  email: "theredstonesheep@gmail.com",
  about: "Hi, I am the admin :)",
  password: "123456789",
  password_confirmation: "123456789",
  role: Role.get(:superadmin),
  confirm_code: SecureRandom.hex(16)
  )