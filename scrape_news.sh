#!/bin/bash
chmod +x ./scrape_news.sh
wget -q https://www.ynetnews.com/category/3082 -O news.txt
grep -o "https://www.ynetnews.com/article/[0-9A-Za-z]\{9\}" news.txt\
> articles.txt
sort articles.txt | uniq > articles_sort.txt
cat articles_sort.txt | wc -l > results.csv

#for every link we search for appearances of 'Gantz' or 'Netanyahu'
for art_link in `cat articles_sort.txt`; do
	wget -q $art_link -O tmp_news.txt
	Netanyahu_counter=`grep Netanyahu tmp_news.txt | wc -l`
	Gantz_counter=`grep Gantz tmp_news.txt | wc -l`
	echo -n "$art_link, " >> results.csv

	#check if both counters are zero - end condition
	if [[ $Netanyahu_counter -eq 0 ]] && [[ $Gantz_counter -eq 0 ]]; then
		echo "-" >> results.csv
	else
		echo -n "Netanyahu, $Netanyahu_counter, " >> results.csv
		echo "Gantz, $Gantz_counter" >> results.csv
	fi
done