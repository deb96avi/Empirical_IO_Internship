# Input files:

1. ensemble.xls: Population at commune level (https://www.insee.fr/fr/statistiques/4265429?sommaire=4265511)
                 
2. communes-departement-region.csv: Geographical location of each commune (https://www.data.gouv.fr/en/datasets/communes-de-france-base-des-codes-postaux/)

3. attraction_city.xlsx: 2020 city attraction zoning areas. Consists of Pole (highly dense population) and Suburbs (https://www.insee.fr/fr/statistiques/5039879?sommaire=5040030)

4. etablissements.csv: Optique shop level data. Go to wesite-> build a list-> Check Active establishment box-> Activity-> 47.78A from Dropdown (https://sirene.fr/sirene/public/accueil)

5. optiques_200_centres_modified.xlsx: manually labelled optique stores' memberships for 200 least populated attraction zones

# Running R code:

It is in a markdown format, similar to python jupyter notebooks. One can run it block by block using ctrl+enter. Brief structure of code is as follows:-

* Takes input data on population, geographical location, attraction zone labels of communes and firm level data from INSEE/Siren websites.
* Remove communes not in mainland France
* Column names are renamed to be more intuitive. 
* Primary key columns are cleaned so that the datasets can be merged
* After merging with siren data on stores, we manually label store networks in top 200 least populated attraction zones.
* Run python script to get latitude-longitude for each store. Refer for API script: https://adresse.data.gouv.fr/api-doc/adresse
* Some codes run online because of library installation and internet setting issues on local computer. 
* Run run_online_address_geo_matching.ipynb on https://colab.research.google.com/
* Run run_online_top_communes_map.rmd on https://rstudio.cloud/
* Do summary statistics

# Labelling of store networks:

Check the name of commune in which a store is located and write in google maps: “opticians in <commune name>”. This gives a list of most optiques in dataset. Check for a store using store name+address. If a store is not available in maps, write the full name and address in google search. If it is still not there, leave the columns blank since it may mean that the optique closed down or is brand new. Each column labelling is explained as follows:-

* Franchise: It is displayed in images of the shop or website. Refer to pg 63 of xerfi document for list of franchises.
* Networks: 
    * If franchise is Optic 2000, go to website->health partners. It displays networks.
    * If franchise is not Optic 2000, carefully observe latest image/street view. Network posters are usually clustered together at main entrance of the shop.
    * In case it is difficult to decipher from images, check websites. Some websites do mention their network affiliations. 
* Audio Service:
    * If franchise is Optic 2000, go to website->services. It displays whether audio service is available or not.
    * If franchise is not Optic 2000, carefully observe latest image/street view. 
    * Finally, check services section of websites. They mention whether audio services are provided. 
* Image date:
    * If network affiliation data obtained from websites (like Optic 2000), mention current date of entry
    * If network affiliation data obtained from google map images, mention image upload date.
