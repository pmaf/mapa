ARGS_Cont_Dist_CAOP2023 = -Z6 -z9
ARGS_Cont_Mun_CAOP2023 = -Z10 -z11
ARGS_Cont_Freg_CAOP2023 = -Z12 -z13
ARGS_rgg = -Z14 -z16 -y area_m2
ARGS_cad = -Z14 -z16 -y nationalcadastralreference -y areavalue -y administrativeunit

mapa.pmtiles: $(patsubst ARGS_%, %.pmtiles, $(filter ARGS_%, $(.VARIABLES)))
	tile-join -o $@ $^

%.pmtiles: %.geojsons
	tippecanoe -X $(ARGS_$*) -pn -pS -ah -l $* -o $@ $<

rgg.geojsons: rgg.gpkg
	ogr2ogr $@ $<

cad.geojsons:
	ogr2ogr $@ WFS:https://snicws.dgterritorio.gov.pt/geoserver/inspire/ows?service=WFS&request=GetCapabilities&version=2.0.0

Cont_%.geojsons: caop_c.gpkg
	ogr2ogr $@ $< Cont_$*

rgg.gpkg:
	wget https://dados.gov.pt/pt/datasets/r/8dedcd3e-ba46-4f0f-a75f-36e0b327fc56 -O $@

caop_c.gpkg:
	wget -qO- https://dados.gov.pt/pt/datasets/r/5c541c6e-e27b-44d9-a7a0-962c9a8b4b94 | funzip > $@