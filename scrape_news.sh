#!/bin/bash
chmod +x ./scrape_news.sh
wget -q https://www.ynetnews.com/category/3082 -O all_news.txt
grep -o 'https://www.ynetnews.com/article/[0-9A-Za-z]\{9\}[#"]' all_news.txt\
> articles.txt
sort articles.txt | uniq > articles_sort.txt
cat articles_sort.txt | wc -l > results.csv
#for every link we search for appearances of 'Gantz' or 'Netanyahu'
for art_link in `cat articles_sort.txt`; do
	#we need to "fix" art_link - remove the last char in it - # or "
	fixed_link=`echo "${art_link::-1}"`
	echo -n "$fixed_link, " >> results.csv
	wget -q $fixed_link -O current_article.txt
	Netanyahu_counter=`cat current_article.txt | grep -o 'Netanyahu' | wc -l`
	Gantz_counter=`cat current_article.txt | grep -o 'Gantz' | wc -l`

	#check if both counters are zero - end condition
	if [[ Netanyahu_counter -eq 0 ]] && [[ Gantz_counter -eq 0 ]]; then
		echo "-" >> results.csv
	else
		echo -n "Netanyahu, $Netanyahu_counter, " >> results.csv
		echo "Gantz, $Gantz_counter" >> results.csv
	fi
done