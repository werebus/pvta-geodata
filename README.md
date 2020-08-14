Repository for generating and displaying PVTA geodata converted from the GTFS
feed data.

Data files
==========
Data are stored in "geo-json" files, which GitHub (conveniently) displays as
maps.

* [All PVTA stops](pvta_stops.geojson)
* [All PVTA route polylines](pvta_routes.geojson)

Generation
=============
```
$ rake generate
```

Note that the `.geojson` files won't be regenerated unless the `gfts.zip` file
(git ignored) is more recent than them. To force regeneration, run `rake clean`
first.
