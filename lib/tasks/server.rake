namespace :server do
  task restart: :environment do
    exec 'touch tmp/restart.txt'
  end

  task console: :environment do
    exec 'rails c -e production'
  end
end
