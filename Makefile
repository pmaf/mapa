TC_cc_Dist = -Z6 -z9
TC_cc_Mun = -Z10 -z11
TC_cc_Freg = -Z12 -z13
TC_rgg = -Z14 -z15 -D11 -d13 -y area_m2
TC_cad = -Z14 -z15 -D11 -d13 -y nationalcadastralreference -y areavalue -y administrativeunit
GP_caop_c = wget -qO- geo2.dgterritorio.gov.pt/caop/CAOP_Continente_2023-gpkg.zip | funzip > $@
GP_rgg = wget dados.gov.pt/pt/datasets/r/8dedcd3e-ba46-4f0f-a75f-36e0b327fc56 -O $@
GP_cad = ogr2ogr $@ WFS:'https://snicws.dgterritorio.gov.pt/geoserver/inspire/ows?service=WFS&request=GetCapabilities&version=2.0.0'

mapa.pmtiles: $(patsubst TC_%, %.pmtiles, $(filter TC_%, $(.VARIABLES)))
	tile-join -o $@ $^

%.pmtiles: %.geojsons
	tippecanoe -X $(TC_$*) -pn -pS -ah -l $* -o $@ $<

%.geojsons: %.gpkg; ogr2ogr $@ $<

cc_%.geojsons: caop_c.gpkg
	ogr2ogr $@ $< Cont_$*_CAOP2023

%.gpkg:; $(GP_$*)