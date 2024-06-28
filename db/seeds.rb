require 'bcrypt'
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


User.create([
    { email: 'jane.smith@example.com', encrypted_password: BCrypt::Password.create('password123'), created_at: Time.now, updated_at: Time.now },
    { email: 'alice.johnson@example.com', encrypted_password: BCrypt::Password.create('password123'), created_at: Time.now, updated_at: Time.now },
    { email: 'bob.brown@example.com', encrypted_password: BCrypt::Password.create('password123'), created_at: Time.now, updated_at: Time.now },
    { email: 'charlie.davis@example.com', encrypted_password: BCrypt::Password.create('password123'), created_at: Time.now, updated_at: Time.now }
  ])
  
  User.find_by(email: 'jane.smith@example.com').search_histories.create([
    { query: 'Best Ruby on Rails tutorials', created_at: Time.now, updated_at: Time.now, search_engine: 'Google' }
  ])
  
  User.find_by(email: 'alice.johnson@example.com').search_histories.create([
    { query: 'What is the latest Rails version?', created_at: Time.now, updated_at: Time.now, search_engine: 'DuckDuckGo' }
  ])
  
  User.find_by(email: 'bob.brown@example.com').search_histories.create([
    { query: 'Rails vs Django comparison', created_at: Time.now, updated_at: Time.now, search_engine: 'Bing' }
  ])
  
  User.find_by(email: 'charlie.davis@example.com').search_histories.create([
    { query: 'Setting up Rails with PostgreSQL', created_at: Time.now, updated_at: Time.now, search_engine: 'Google' }
  ])
  