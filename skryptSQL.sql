create extension postgis
create extension postgis_raster

.\raster2pgsql -s 27700 -I -N -32767 -C -M C:\Users\micha\OneDrive\Pulpit\bazyZad\zad7\ras250_gb\data\*.tif -F -t 100x100 rasters.uk_250k | .\psql -d zad7 -h localhost -U postgres -p 5432

raster2pgsql.exe -s 27700 -I -N -32767 -C -M C:\Users\micha\OneDrive\Pulpit\bazyZad\zad7\ras250_gb\data\*.tif -F -t 100x100 public.uk_250k | psql -d zad7 -h localhost -U postgres -p 5432

C:\Users\micha\OneDrive\Pulpit\bazyZad\zad7\ras250_gb\data


--z poprzedich zajec
raster2pgsql.exe -s 3763 -N -32767 -t 128x128 -I -C -M -d C:\Users\micha\OneDrive\Pulpit\bazyZad\Dane-Cw6\rasters\Landsat8_L1TP_RGBN.TIF rasters.landsat8|psql -d bazyDanychPrzestrzennych -h localhost -U postgres -p 5432

select * FROm uk_250k

--klucz glowny juz u nas istnieje

--utworzenie indeksu przestrzennego
CREATE INDEX idx_uk_250k ON public.uk_250k
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('public'::name,
'uk_250k'::name,'rast'::name);


--ZAD3 -- polacz te dane w mozaike, a nastepnie wyeksportuj jako GeoTIFF

CREATE TABLE public.uk_250k_mosaic AS
SELECT ST_Union(r.rast)
FROM public.uk_250k AS r

--Zad4 - pobierz dane o nazwie OS Open Zoomstack ze strony

--Zad5 -- po wrzuceniu danych do qgisa zaznaczyle tylko warstwe ktora chce wyeksporotwac i eksportuje jakos postgres dump

SELEct * FROM parkigranice
--zad6
--pytanie jakie jest id paru Lake District
CREATE TABLE public.uk_lake_district AS
SELECT r.rid, ST_Clip(r.rast, u.wkb_geometry, true) AS rast, u.id
FROM public.uk_250k AS r, public.parkigranice AS u
WHERE ST_Intersects(r.rast, u.wkb_geometry) AND u.id = 1;


--ok
-- 7. Wyeksportuj wyniki do pliku geoTif.
CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
       ST_AsGDALRaster(ST_Union(rast), 'GTiff',  ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
        ) AS loid
FROM pub.uk_lake_district;

SELECT lo_export(loid, 'F:\zad7lake_district.tif')
FROM tmp_out;





