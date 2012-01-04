ant -Dproperties.file=dev-upgrade.properties test:all

wsrf-get-property.bat -a -z none -s http://cbiovdev5051.nci.nih.gov:19880/wsrf/services/cagrid/MaGridService {gme://caGrid.caBIG/1.0/gov.nih.nci.cagrid.metadata}ServiceMetadata

wsrf-get-property.bat -a -z none -s http://cbiovdev5051.nci.nih.gov:19880/wsrf/services/cagrid/MaGridService  {gme://caGrid.caBIG/1.0/gov.nih.nci.cagrid.metadata.dataservice}DomainModel

REM wsrf-get-property.bat -a -z none -s http://cabiogrid42-dev.nci.nih.gov:80/wsrf/services/cagrid/CaBIO42GridSvc  {gme://caGrid.caBIG/1.0/gov.nih.nci.cagrid.metadata.dataservice}DomainModel
