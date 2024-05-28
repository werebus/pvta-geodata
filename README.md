Repository for generating and displaying PVTA geodata converted from the GTFS
feed data.

Data files
==========
Data are stored in "geo-json" files. GitHub used to render them directly, but
it appears that, with a recent switch to Bing Maps, that the functionality of
the rendered maps had been significantly reduced.


Generation
=============
```
$ rake generate
```

Note that the `.geojson` files won't be regenerated unless the `gfts.zip` file
(git ignored) is more recent than them. To force regeneration, run `rake clean`
first.
