# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
deleted_user = User.new({
  name: "Deleted user",
  ign: "Steve",
  email: "example@example.com",
  about: "Hey, apparently, I do no longer exist. This is just a placeholder profile",
  password: "D6^w,:A})@/y>@$18u%D2,_@Se{%>$=,14Nc>#Oz4.[eP$X0p'1fW'%=60H{7]i'H);<r:!'Zt$-X58])#!/l;)}=$@'2W>oX(epMK5B2>/l]t(!_T3p,,]e@Uh%]Vq%[~)_~$?=[6S#8%H&JOd#/#|PRH2/q?!]%(#1;6&_*u&%-+&G-dP*j,1x+@+.6]#6{H$]=I",
  password_confirmation: "D6^w,:A})@/y>@$18u%D2,_@Se{%>$=,14Nc>#Oz4.[eP$X0p'1fW'%=60H{7]i'H);<r:!'Zt$-X58])#!/l;)}=$@'2W>oX(epMK5B2>/l]t(!_T3p,,]e@Uh%]Vq%[~)_~$?=[6S#8%H&JOd#/#|PRH2/q?!]%(#1;6&_*u&%-+&G-dP*j,1x+@+.6]#6{H$]=I",
  rank: 10
  })
deleted_user.update_attribute("skype", "echo123")
deleted_user.update_attribute("skype_public", true)
deleted_user.update_attribute("last_ip", "0.0.0.0")
deleted_user.update_attribute("last_login", Time.utc(0).to_datetime)
deleted_user.update_attribute("last_active", Time.utc(0).to_datetime)
deleted_user.update_attribute("created_at", Time.utc(0).to_datetime)
deleted_user.update_attribute("updated_at", Time.utc(0).to_datetime)
deleted_user.save

User.create(
  name: "Redstone Sheep",
  ign: "noobkackboon",
  email: "theredstonesheep@gmail.com",
  about: "Hi, I am the admin :)",
  password: "123",
  password_confirmation: "123",
  rank: 500
  )