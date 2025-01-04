TC_cc_Mun = -Z7 -z11
TC_cc_Freg = -Z12 -z13
TC_cm_Mun = -Z7 -z11
TC_cm_Freg = -Z12 -z13
TC_rgg = -Z14 -z15 -D11 -d13 -y area_m2
TC_cad = -Z14 -z15 -D11 -d13 -y nationalcadastralreference -y areavalue -y administrativeunit
TC_cad_m = -Z14 -z15 -D11 -d13 -y nic -y matriz_artigo -y natureza -y area_cadastral_m2
TC_crus = -Z13 -z13 -y Classe -y Categoria

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

CAOP_%.gpkg:
	wget -qO- geo2.dgterritorio.gov.pt/caop/CAOP_$*_2023-gpkg.zip | funzip > $@

rgg.gpkg:
	wget dados.gov.pt/pt/datasets/r/8dedcd3e-ba46-4f0f-a75f-36e0b327fc56 -O $@

cad.gpkg:
	ogr2ogr $@ WFS:'https://snicws.dgterritorio.gov.pt/geoserver/inspire/ows?service=WFS'

cad_m.gpkg:
	ogr2ogr $@ WFS:'https://geoservices.madeira.gov.pt/geoserver/CadastroPredial/wfs?&service=WFS'

# https://dados.gov.pt/pt/datasets/carta-do-regime-de-uso-do-solo-portugal-continental/
# TODO: Stop using MAXFEATURES if possible
crus.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSCRUS/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=300000'