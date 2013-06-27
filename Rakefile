FeedURL = "http://pvta.com/g_trans/google_transit.zip"
FilePath = "gtfs/google_transit.zip"

desc "Fetch and unzip new gtfs data"
task :gtfs => "gtfs:default"
namespace :gtfs do
  desc "Remove any existing gtfs data"
  task :clean do
    system "rm -v gtfs/*"
  end

  desc "Download the gtfs zip file"
  task :fetch do
    system "curl -o #{FilePath} #{FeedURL}"
  end

  desc "unzip the gtfs zip file"
  task :unzip do
    system "unzip #{FilePath} -d gtfs/"
  end

  task :default => [:clean, :fetch, :unzip]
end
