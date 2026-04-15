#!/bin/bash
#Author Takumi Yamada
#since April 01, 2026
#Tuna Prices Data Analysis with Bash 

FILE="tokyo_wholesale_tuna_prices.csv"


echo "===================================================="
echo "Tokyo Wholesale Tuna Prices Analysis - Takumi Yamada"

echo "===================================================="
if [ ! -f "$FILE" ];
then 
  echo "Error!! File not found: $FILE"
  exit 1
fi
echo "===================================================="
echo "Total number of data rows (excluding header):"
tail -n +2 "$FILE" | wc -l

echo "===================================================="
echo "Columns:"
head -1 "$FILE" | tr ',' '\n' | nl

echo "===================================================="
echo "Species:"
cut -d',' -f4 "$FILE" | tail -n +2 | sort | uniq -c | sort -n -r |
while read count species1 species2
do 
    species="$species1"
    if [ -n "$species2" ];
    then
      species="$species1 $species2"
    fi
    # echo "$species: $count"
    echo "$count  $species" | sed 's/^\([0-9]*\) \(.*\)$/\2: \1/'
done    

echo "===================================================="
echo "State values:"
cut -d',' -f5 "$FILE" | tail -n +2 | sort | uniq -c | sort -n -r |
while read count state
do 
    echo "$state: $count"
done

echo "===================================================="
echo "Fleet values:"
cut -d',' -f6 "$FILE" | tail -n +2 | sort | uniq -c | sort -n -r |
while read count fleet1 fleet2
do
    fleet="$fleet1"
    if [ -n "$fleet2" ];
    then
      fleet="$fleet1 $fleet2"
    fi
    echo "$fleet: $count"
done

echo "===================================================="
grep 'Price' "$FILE" | cut -d',' -f3 > price.txt
grep 'Quantity' "$FILE" | cut -d',' -f3 > quantity.txt

# PRICE_SUM=$(paste -s -d+ price.txt | bc)
PRICE_SUM=$(xargs < price.txt | sed 's/ /+/g' | bc)
PRICE_COUNT=$(wc -l < price.txt)
PRICE_AVG=$(echo "scale=3; $PRICE_SUM / $PRICE_COUNT" | bc)

PRICE_MIN=$(sort -n price.txt | head -1)
PRICE_MAX=$(sort -n -r price.txt | head -1)

echo "Price statistics:"
echo "Average price: $PRICE_AVG"
echo "Minimum price: $PRICE_MIN"
echo "Maximum price: $PRICE_MAX"

echo "Top 5 highest prices:"
sort -n -r price.txt | head -5

# QUANTITY_SUM=$(paste -s -d+ quantity.txt | bc)
QUANTITY_SUM=$(xargs < quantity.txt | sed 's/ /+/g' | bc)
QUANTITY_COUNT=$(wc -l < quantity.txt)
QUANTITY_AVG=$(echo "scale=3; $QUANTITY_SUM / $QUANTITY_COUNT" | bc)

QUANTITY_MIN=$(sort -n quantity.txt | head -1)
QUANTITY_MAX=$(sort -n -r quantity.txt | head -1)

echo "===================================================="
echo "Quantity statistics:"
echo "Average quantity: $QUANTITY_AVG"
echo "Minimum quantity: $QUANTITY_MIN"
echo "Maximum quantity: $QUANTITY_MAX"

echo "Top 5 highest quantities:"
sort -n -r quantity.txt | head -5



rm -f price.txt quantity.txt
