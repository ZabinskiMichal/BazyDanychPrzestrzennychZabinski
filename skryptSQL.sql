create extension postgis
create extension postgis_raster

.\raster2pgsql -s 27700 -I -N -32767 -C -M C:\Users\micha\OneDrive\Pulpit\bazyZad\zad7\ras250_gb\data\*.tif -F -t 100x100 rasters.uk_250k | .\psql -d zad7 -h localhost -U postgres -p 5432

raster2pgsql.exe -s 27700 -I -N -32767 -C -M C:\Users\micha\OneDrive\Pulpit\bazyZad\zad7\ras250_gb\data\*.tif -F -t 100x100 public.uk_250k | psql -d zad7 -h localhost -U postgres -p 5432

C:\Users\micha\OneDrive\Pulpit\bazyZad\zad7\ras250_gb\data


--z poprzedich zajs
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


