# gwc-docker

Test container for trying out serving existing mbtiles file from GeoWebCache.

To build:

1. Put the geowebcache.war in the main folder of this project.
2. Put your .mbtiles file in `/data`
3. Edit `/data/geowebcache.xml` to point to your data file.
4. Edit `/ROOT/index.html` to point to the correct layer name (if something other than OSM).
4. Build the container `docker build --rm -t local/gwc .`
5. Run the container `docker run -it --rm --name gwc -p 8080:8080 local/gwc`
6. Open `http://localhost:8080/index.html

**TODO:**
* Fix styling of demo (in `/ROOT/`)


