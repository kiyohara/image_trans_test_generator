# ImageTransTestGenerator

Image URI listup tool for HTTP transport quality test.

## Installation

Add this line to your application's Gemfile:

```ruby
source 'https://rubygems.org'

gem 'image_trans_test_generator', github: 'kiyohara/image_trans_test_generator'
```

And then execute:

```console
$ bundle
```

## Usage

1. create Site URL list

```console
$ vim site_url_list.txt
```

```
https://www.google.co.jp/
http://www.yahoo.co.jp/
https://www.youtube.com/
http://www.amazon.co.jp/
https://www.google.com/
```

2. list up Image URL from `<img>` tags `src` attribute in above sites)

```console
$ bundle exec image_trans_test_generator bulk_list_images \
  --file site_url_list.txt \
  --uniq \
  --filter_has_query \
  --update_with_http_trans \
  > image_url_list.ltsv
```

3. pickup Image URL above image list file

``` console
$ ../exe/image_trans_test_generator pickup_test_images \
  --file image_url_list.ltsv \
  --image_size_total 2000000 \
  --image_size_min     10000 \
  --image_size_max    500000 \
  --snip_domain_depth 2
```

| option | desc |
|--|--|
| `--image_size_total`  | total size limit(byte) of image picked up      |
| `--image_size_max`    | upper size limit(byte) of each image picked up |
| `--image_size_min`    | lower size limit(byte) of each image picked up |
| `--snip_domain_depth` | domain snipping depth from TLD (†)            |

† snipped domain is information used to pickup image.
this tool grouping images by snipped domain in internal.

| original image domain   | `--snip_domain_depth 3` | `--snip_domain_depth 2` |
|--|--|
| `hoge.fuga.example.com` | `fuga.example.com`      | `example.com`           |
| `example.com`           | `example.com`           | `example.com`           |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kiyohara/image_trans_test_generator.
