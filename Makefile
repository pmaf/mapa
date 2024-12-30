TC_cc_Mun = -Z7 -z11
TC_cc_Freg = -Z12 -z13
#TC_cm_Mun = -Z7 -z11
#TC_cm_Freg = -Z12 -z13
TC_rgg = -Z14 -z15 -D11 -d13 -y area_m2
TC_cad = -Z14 -z15 -D11 -d13 -y nationalcadastralreference -y areavalue -y administrativeunit
#TC_cad_m = -Z14 -z15 -D11 -d13 -y nic -y matriz_artigo -y natureza -y area_cadastral_m2
#TC_censos_sec_CONT = -Z15 -z15
#TC_censos_sec_MAD = -Z15 -z15

mapa.pmtiles: $(patsubst TC_%, %.pmtiles, $(filter TC_%, $(.VARIABLES)))
	tile-join -o $@ $^

%.pmtiles: %.geojsons
	tippecanoe -X $(TC_$*) -pn -pS -ah -l $* -o $@ $<

%.geojsons: %.gpkg
	ogr2ogr $@ $<

cc_%.geojsons: CAOP_Continente.gpkg
	ogr2ogr $@ $< Cont_$*_CAOP2023

cm_%.geojsons: CAOP_RAM.gpkg
	ogr2ogr $@ $< ArqMadeira_$*_CAOP2023

censos_sec_%.geojsons: censos_sec.gpkg
	ogr2ogr $@ $< C2021_SECCOES_$*

# Missing 3763 EPSG in censos_sec.gpkg
censos_sec_CONT.geojsons: censos_sec.gpkg
	ogr2ogr $@ $< C2021_SECCOES_CONT -s_srs EPSG:3763 -t_srs EPSG:4326

# Missing 5015 EPSG in censos_sec.gpkg
censos_sec_AC26.geojsons: censos_sec.gpkg
	ogr2ogr $@ $< C2021_SECCOES_AC26 -s_srs EPSG:5015 -t_srs EPSG:4326

CAOP_%.gpkg:
	wget -qO- geo2.dgterritorio.gov.pt/caop/CAOP_$*_2023-gpkg.zip | funzip > $@

rgg.gpkg:
	wget dados.gov.pt/pt/datasets/r/8dedcd3e-ba46-4f0f-a75f-36e0b327fc56 -O $@

cad.gpkg:
	ogr2ogr $@ WFS:'https://snicws.dgterritorio.gov.pt/geoserver/inspire/ows?service=WFS'

cad_m.gpkg:
	ogr2ogr $@ WFS:'https://geoservices.madeira.gov.pt/geoserver/CadastroPredial/wfs?&service=WFS'

censos_sec.gpkg:
	wget -qO- mapas.ine.pt/download/filesGPG/2021Seccoes/C2021_SECCOES_PT.zip | funzip > $@

censos_subsec.gpkg:
	wget mapas.ine.pt/download/filesGPG/2021/portugal2021.zip
	unzip -p portugal2021.zip portugal2021.gpkg > $@
	rm portugal2021.zip