TC_cc_Mun = -Z7 -z11
TC_cc_Freg = -Z12 -z13
TC_cm_Mun = -Z7 -z11
TC_cm_Freg = -Z12 -z13
TC_rgg = -Z14 -z15 -D11 -d13 -y area_m2
TC_cad = -Z14 -z15 -D11 -d13 -y nationalcadastralreference -y areavalue -y administrativeunit
TC_cad_m = -Z14 -z15 -D11 -d13 -y nic -y matriz_artigo -y natureza -y area_cadastral_m2
TC_crus = -Z12 -z12 -y Classe
TC_srup_ran = -zg
TC_srup_oah = -zg
TC_srup_dn = -zg -y DESIGNACAO
TC_srup_aapc = -zg -y DESIGNACAO
TC_srup_ipe = -zg -y DESIGNACAO
TC_srup_mg = -zg -y DESIGNAÇÃO
TC_srup_rf = -zg -y DESIGNACAO

mapa.pmtiles: $(patsubst TC_%, %.pmtiles, $(filter TC_%, $(.VARIABLES)))
	tile-join -o $@ $^

%.pmtiles: %.geojsons
	tippecanoe -X $(TC_$*) -pn -pS -ah -l $* -o $@ $<

# FIXME: Converting crus.gpkg to crus.geojsons results in null geometry
crus.pmtiles: %.geojson
	tippecanoe -X $(TC_$*) -pn -pS -ah -l $* -o $@ $<

%.geojsons: %.gpkg
	ogr2ogr $@ $<

%.geojson: %.gpkg
	ogr2ogr $@ $< -lco RFC7946=YES

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

crus.gpkg: solo.gpkg
	ogr2ogr $@ $< -sql "SELECT Classe, ST_Union(Geometry) AS geometry FROM 'gmgml:CRUS' GROUP BY Classe"

# https://dados.gov.pt/pt/datasets/carta-do-regime-de-uso-do-solo-portugal-continental/
# FIXME: Stop using MAXFEATURES
solo.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSCRUS/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=300000'

# FIXME: Make a generic srup_%.gpkg target. Currently not possible due to different MAXFEATURES values
srup_ran.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_RAN_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=1000'

srup_ren.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_REN_PT1/WFService.aspx?service=WFS'

srup_dph.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_DPH_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=1000'

srup_ap.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_AP_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=1000'

srup_mg.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_MG_PT1/WFService.aspx?service=WFS&TYPENAMES=gmgml:Zona_de_Segurança_aos_Marcos_Geodésicos&VERSION=1.1.0&MAXFEATURES=10000'

srup_ia.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_IA_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=1000'

srup_rf.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_RF_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=1000'

srup_dn.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_DN_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=1000'

srup_ic.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_IC_PT1/WFService.aspx?service=WFS&TYPENAMES=gmgml:Imóveis_Classificados_com_Zona_de_Proteção&VERSION=1.1.0&MAXFEATURES=10000'

srup_rg.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_RG_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=5000'

srup_aa.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_AA_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=1000'

srup_go.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_GO_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=1000'

srup_aip.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_AIP_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=1000'

srup_ipe.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_IPE_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=1000'

srup_eip.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_EIP_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=1000'

srup_oah.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_OAH_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=10000'

srup_aapc.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_AAPC_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=10000'

srup_eptm.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_EPTM_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=10000'

srup_cpir.gpkg:
	ogr2ogr $@ WFS:'https://servicos.dgterritorio.pt/SDISNITWFSSRUP_CPIR_PT1/WFService.aspx?service=WFS&VERSION=1.1.0&MAXFEATURES=1000000'
