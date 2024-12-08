.PRECIOUS: rgg.geojsons cadastro.geojsons

FIELDS_rgg = area_m2
FIELDS_cadastro = nationalcadastralreference areavalue administrativeunit

ZOOMS_caop_cont_dist = 6 9
ZOOMS_caop_cont_mun = 10 11
ZOOMS_caop_cont_freg = 12 13
ZOOMS_rgg = 14 16
ZOOMS_cadastro = 14 16

mapa.pmtiles: caop_cont_dist.pmtiles caop_cont_mun.pmtiles caop_cont_freg.pmtiles rgg.pmtiles cadastro.pmtiles
	tile-join -o $@ $^

%.pmtiles: %.geojsons
	tippecanoe \
	  -Z $(word 1,$(ZOOMS_$*)) \
	  -z $(word 2,$(ZOOMS_$*)) \
	  --exclude-all \
      $(foreach y,$(FIELDS_$*),-y $(y)) \
      --no-simplification-of-shared-nodes \
      --simplify-only-low-zooms \
	  --hilbert \
      -l $* -o $@ $<

rgg.geojsons: rgg.gpkg
	ogr2ogr $@ $<

cadastro.geojsons:
	ogr2ogr $@ https://dados.gov.pt/pt/datasets/r/ddc83a71-580c-4d34-bec8-fb6b9d0a56d3

caop_cont_dist.geojsons: caop_cont.gpkg
	ogr2ogr $@ $< Cont_Dist_CAOP2023

caop_cont_mun.geojsons: caop_cont.gpkg
	ogr2ogr $@ $< Cont_Mun_CAOP2023

caop_cont_freg.geojsons: caop_cont.gpkg
	ogr2ogr $@ $< Cont_Freg_CAOP2023

rgg.gpkg:
	wget https://dados.gov.pt/pt/datasets/r/8dedcd3e-ba46-4f0f-a75f-36e0b327fc56 -O $@

caop_cont.gpkg:
	wget -qO- https://geo2.dgterritorio.gov.pt/caop/CAOP_Continente_2023-gpkg.zip | funzip > $@