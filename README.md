Repository for generating and displaying PVTA geodata converted from the GTFS
feed data.

Data files
==========
Data are stored in "geo-json" files, which GitHub (conveniently) displays as
maps.

* [All PVTA stops][stops]
* [All PVTA route polylines][routes]

Generation
=============
```
$ rake generate
```

Note that the `.geojson` files won't be regenerated unless the `gfts.zip` file
(git ignored) is more recent than them. To force regeneration, run `rake clean`
first.

[stops]: blob/master/pvta_stops.geojson
[routes]: blob/master/pvta_routes.geojson
