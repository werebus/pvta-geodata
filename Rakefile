# frozen_string_literal: true

require 'pathname'
require 'rake/clean'

$LOAD_PATH.unshift Pathname(__dir__).join('lib').expand_path
require 'feed_zip_file'
require 'generator'
require 'routes_generator'
require 'stops_generator'

FEED_FILE = Pathname(__dir__).join('gtfs.zip').expand_path

desc 'Fetch gtfs data from PVTA'
file FEED_FILE.basename do
  fz = FeedZipFile.new('http://pvta.com/g_trans/google_transit.zip', FEED_FILE)
  fz.fetch!
end
CLEAN << FEED_FILE

desc 'Generate stops file'
file 'pvta_stops.geojson' => FEED_FILE.basename do
  sg = StopsGenerator.new(FEED_FILE)
  File.write('pvta_stops.geojson', sg.json)
end
CLOBBER << 'pvta_stops.geojson'

desc 'Generate routes file'
file 'pvta_routes.geojson' => FEED_FILE.basename do
  rg = RoutesGenerator.new(FEED_FILE)
  File.write('pvta_routes.geojson', rg.json)
end
CLOBBER << 'pvta_routes.geojson'

desc 'Generate all files'
task 'generate' => ['pvta_stops.geojson', 'pvta_routes.geojson']
