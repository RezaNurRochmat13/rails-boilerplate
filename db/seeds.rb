# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Seeding users..."

users = [
  { name: "Reza Rochmat", email: "reza@example.com" },
  { name: "Ahmad Santoso", email: "ahmad@example.com" },
  { name: "Dewi Lestari", email: "dewi@example.com" },
  { name: "Putri Anggraini", email: "putri@example.com" },
  { name: "Budi Prasetyo", email: "budi@example.com" },
  { name: "Siti Nurhaliza", email: "siti@example.com" },
  { name: "Andi Wijaya", email: "andi@example.com" },
  { name: "Rina Kartika", email: "rina@example.com" },
  { name: "Fajar Setiawan", email: "fajar@example.com" },
  { name: "Tika Wulandari", email: "tika@example.com" }
]

users.each do |u|
  User.find_or_create_by!(email: u[:email]) do |user|
    user.name = u[:name]
  end
end

puts "✅ Done seeding users (#{User.count})"
