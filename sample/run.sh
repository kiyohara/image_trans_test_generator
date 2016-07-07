#!/usr/bin/env bash
THIS_FILE_PATH=${BASH_SOURCE[0]-$0}
THIS_FILE_DIR=$(cd $(dirname $THIS_FILE_PATH); pwd)
######################################################################

cd $THIS_FILE_DIR

URI_LIST=uri_list.txt
if [ ! -e $URI_LIST ];then
  URI_LIST=uri_list.txt.sample
fi
echo '**' $URI_LIST handling ...

../exe/image_trans_test_generator bulk_list_images \
  --file $URI_LIST \
  --uniq \
  --filter_has_query \
  --update_with_http_trans \
  > _list.ltsv \
  &&

../exe/image_trans_test_generator pickup_test_images \
  --file _list.ltsv \
  --image_size_total 2000000 \
  --image_size_min     10000 \
  --image_size_max    500000 \
  --snip_domain_depth 2 \
  > _test_set.txt \
  &&

echo generation finish

# cat _test_set.txt
