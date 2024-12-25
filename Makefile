ARGS_Cont_Dist_CAOP2023 = -Z6 -z9
ARGS_Cont_Mun_CAOP2023 = -Z10 -z11
ARGS_Cont_Freg_CAOP2023 = -Z12 -z13
ARGS_rgg = -Z14 -z15 -D11 -d13 -y area_m2
ARGS_cad = -Z14 -z15 -D11 -d13 -y nationalcadastralreference -y areavalue -y administrativeunit

.INTERMEDIATE: $(patsubst ARGS_%, %.pmtiles %.geojsons, $(filter ARGS_%, $(.VARIABLES)))

mapa.pmtiles: $(patsubst ARGS_%, %.pmtiles, $(filter ARGS_%, $(.VARIABLES)))
	tile-join -o $@ $^

%.pmtiles: %.geojsons
	tippecanoe -X $(ARGS_$*) -pn -pS -ah -l $* -o $@ $<

%.geojsons: %.gpkg
	ogr2ogr $@ $<

Cont_%.geojsons: caop_c.gpkg
	ogr2ogr $@ $< Cont_$*

caop_c.gpkg:
	wget -qO- https://geo2.dgterritorio.gov.pt/caop/CAOP_Continente_2023-gpkg.zip | funzip > $@

rgg.gpkg:
	wget https://dados.gov.pt/pt/datasets/r/8dedcd3e-ba46-4f0f-a75f-36e0b327fc56 -O $@

cad.gpkg:
	ogr2ogr $@ WFS:'https://snicws.dgterritorio.gov.pt/geoserver/inspire/ows?service=WFS&request=GetCapabilities&version=2.0.0'
