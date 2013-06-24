# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
User.create(
  name: "Redstone Sheep",
  ign: "noobkackboon",
  email: "theredstonesheep@gmail.com",
  about: "Hi, I am the admin :)",
  password: "123",
  password_confirmation: "123",
  rank: 500
  )
User.create(
  name: "Tarkztor",
  ign: "TraksAG",
  email: "tacko@gmail.com",
  about: "Hi, I am another user :)",
  password: "123",
  password_confirmation: "123",
  rank: 10
  )