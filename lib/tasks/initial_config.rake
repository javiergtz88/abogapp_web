namespace :initial_config do
  task set_secret: :environment do
    puts 'Ensure SECRET_KEY_BASE is added in ~/.profile'
    puts "ENV['SECRET_KEY_BASE']=#{ENV['SECRET_KEY_BASE']}"
    puts 'rake secret RAILS_ENV=production'
    puts 'export SECRET_KEY_BASE='
    puts 'RAILS_ENV=production bundle exec rake assets:precompile'
    puts 'DONE...'
  end

  task load_price_pairs: :environment do
    PricePair.new(amount: 1000, price: 5.99).save
    PricePair.new(amount: 5000, price: 23.99).save
    PricePair.new(amount: 10_000, price: 41.99).save
    PricePair.new(amount: 15_000, price: 58.99).save
  end
end
