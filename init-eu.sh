#!/bin/bash

host=http://10.154.0.3
port=9200
index=prods4
url=${host}:${port}/${index}
function initIndex {
    curl -s -XPUT ${url} -d '
{
    "settings": {
        "number_of_shards": 5, 
        "analysis": {
            "filter": {
                "autocomplete_filter": { 
                    "type":     "edge_ngram",
                    "min_gram": 1,
                    "max_gram": 20
                }
            },
            "analyzer": {
                "autocomplete": {
                    "type":      "custom",
                    "tokenizer": "standard",
                    "filter": [
                        "lowercase",
                        "autocomplete_filter" 
                    ]
                }
            }
        }
    }
}' >> elasticsearch.log
}

function initData {
    curl -s -XPOST "${url}/account/_bulk?pretty" --data-binary "@accounts.json"
}

function dropIndex {
    curl -s -XDELETE ${url} >> elasticsearch.log
}

dropIndex
initIndex
initData
