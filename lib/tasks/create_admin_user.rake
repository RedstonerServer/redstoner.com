desc "Creates a superadmin user. Usage: rake create:create_admin_user[uuid, ign, email, pass]"
namespace :create do
  task :create_admin_user, [:uuid, :ign, :email, :pass] => :environment do |task, args|
    User.create!(
      uuid: args.uuid,
      ign: args.ign,
      email: args.email,
      password: args.pass,
      password_confirmation: args.pass,
      role: Role.get(:superadmin),
      header_scroll: false,
      utc_time: false,
      dark: false,
      badge: Badge.get(:donor),
      confirmed: true
    )
  end
end
