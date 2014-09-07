# contact wei.zhang@weimob.com

if [ -z $1 ] || [ -z $2 ];then
    echo "provide file and date"
    echo "example: $0 sql.log 140904"
    exit 1
fi

confirmed="/var/ftp/pub/confirmed.tpl"
all="/var/ftp/pub/all.tpl"
touch $confirmed;
touch $all;

sed -n '/^'$2'/,$p' $1 | perl -pe 's/\n/ /;' | grep  -e "Query\s*\(SELECT\|UPDATE\|DELETE\)" | grep -ivE INFORMATION_SCHEMA\|table_schema\|EXPLAIN | awk -F'Query\t' '{if(NF>1) {$1=""};print $0";"}' | grep -v "SELECT ;" > $2

#split and format
echo "" > format.result
split -l 100 $2 $2.split.
files=(`ls $2.split.*`)
for((i=0; i<${#files[@]}; i++));do
  #echo "formatting " ${files[$i]} 
  ./format ${files[$i]} 2>/dev/null >> format.result
done
rm $2.split.* -f

sort -u format.result | grep -vE "<<<<<<|------------" | grep -E ^SELECT\|^DELETE\|^UPDATE | sed -n 's/\s*$//p' > $2.tpl
cat $2.tpl $all | sort -u > all.tpl.new
cat all.tpl.new $confirmed | sort | uniq -d > dup.tmp.tpl
cat all.tpl.new dup.tmp.tpl | sort | uniq -u > $all
cat $all | grep -E ^SELECT\|^DELETE | grep FROM | sed 's/.*FROM\s*\(\S*\).*/\1--->\0/g' > $2.tpl.unresolved
cat $all | grep -E ^UPDATE | sed 's/^UPDATE\s*\(\S*\)\s*SET.*/\1--->\0/g' >> $2.tpl.unresolved

awk -F"--->" 'BEGIN{old=""} {if(old==$1) {print $2} else {print "\n*******************************************\n"$1"\n*******************************************\n"$2; old=$1}}' $2.tpl.unresolved > /var/ftp/pub/from_$2_to_`date +%y%m%d`.unresolved

# cleanup
rm $2 $2.tpl.unresolved all.tpl.new dup.tmp.tpl format.result $2.tpl -f
