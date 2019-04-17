== to create pdi-ce-8.2-mine.zip

1. make sure there is a valid data-integration directory in this directory with a recent pentaho data-integration ce version.
    * you have to install pentaho-dataset pugin
    * you have to install kettle-needful-things plugin
    * be sure, that spoon.sh and maitre.sh can be run (chmod ugo+x *.sh)

2. delete pdi-ce-8.2-mine.zip

3. zip -r pdi-ce-8.2-mine.zip data-integration/
