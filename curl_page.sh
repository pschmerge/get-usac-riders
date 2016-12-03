#/bin/bash

GENDER=('m' 'f')
CATEGORY=('' 'PR' '01' '02' '03' '04' '05')
TYPE=('Road%3ACX' 'Road%3ACRIT' 'Road%3ARR')

if [ -f doot ]; then
  rm doot
fi

function do_curl() {
  gender=$1
  cat=$2
  page=$3
  type=$4
  curl -X POST -d "mode=show_rank&region=&state=&sex=${gender}&disc=${type}&cat=${cat}&agemin=1&agemax=99&page=${page}" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" https://www.usacycling.org/rankings/points.php | grep rivals > doot
  cat doot | sed s/\<td.*id=//g | sed s/\'\>/\|/g | sed s/\<.*\>//g | awk '{print $1 " " $2 " "$3 " " $4}' >> "file_${gender}_${type}_${cat}.txt"
  rm doot
}

for g in ${GENDER[@]}; do
  echo $g
  for c in ${CATEGORY[@]}; do
  echo $c
    for t in ${TYPE[@]}; do
      for i in `seq 0 10`; do
        do_curl $g $c $i $t
      done
    done
  done
done
