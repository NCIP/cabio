set service.base.url=magridservice-qa.nci.nih.gov:80
set magridservice.url=http://%service.base.url%/wsrf/services/cagrid/MaGridService
set grid.index.url=http://cagrid-index-qa.nci.nih.gov:8080/wsrf/services/DefaultIndexService
set grid.index.service.dump=indexservice.dump
ant -Dgrid.index.url=%grid.index.url% -Dmagridservice.url=%magridservice.url% -Dgrid.index.service.dump=%grid.index.service.dump% -Dservice.base.url=%service.base.url% test:all

wsrf-get-property.bat -a -z none -s %magridservice.url% {gme://caGrid.caBIG/1.0/gov.nih.nci.cagrid.metadata}ServiceMetadata

wsrf-get-property.bat -a -z none -s h%magridservice.url%  {gme://caGrid.caBIG/1.0/gov.nih.nci.cagrid.metadata.dataservice}DomainModel

REM wsrf-get-property.bat -a -z none -s %magridservice.url%  {gme://caGrid.caBIG/1.0/gov.nih.nci.cagrid.metadata.dataservice}DomainModel
