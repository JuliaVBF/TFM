#!bin/bash

for file in ./results.boruta.*.tsv
do 

newName=$(basename "$file" .genus.tsv | sed 's/results.boruta./List.Features./')
Rscript getFeaturesBoruta.R "$file" >> "$newName".txt

done
