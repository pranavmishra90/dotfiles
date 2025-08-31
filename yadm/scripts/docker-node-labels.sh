#!/bin/bash

# create nodes.json first
docker node ls -q | while read -r NODE_ID; do
  docker node inspect "$NODE_ID" --format '{{ .Description.Hostname }}{{ "\t" }}{{ json .Spec.Labels }}'
done | jq -Rn '
  [inputs
    | split("\t")
    | select(length == 2 and .[1] != "null")
    | {hostname: .[0], labels: (.[1] | fromjson)}
  ]
' > nodes.json

# Restructure into a deeply nested json
jq '
{
  hostname: (
    reduce .[] as $node ({}; 
      .[$node.hostname] = { labels: $node.labels }
    )
  )
}
' nodes.json >  nodes.tmp.json

mv nodes.tmp.json nodes.json


# get unique label pairs
unique_label_pairs=$(jq -r '
  .hostname
  | to_entries
  | map(
      .value.labels
      | if type == "object" then
          to_entries | map("\(.key)=\(.value)")
        else []
        end
    )
  | add
  | unique
  | sort
  | .[]
' nodes.json)
echo ""
echo ""
echo "Docker Swarm Nodes and Their Labels"
echo "-------------------------------------"
echo ""
# iterate over pairs
while IFS= read -r label_pair; do
  echo "$label_pair"
  key="${label_pair%%=*}"
  val="${label_pair#*=}"

  jq -r --arg k "$key" --arg v "$val" '
    .hostname
    | to_entries
    | map(select(.value.labels != null and .value.labels[$k] == $v))
    | .[].key
  ' nodes.json | sed 's/^/  -  /'

done <<< "$unique_label_pairs"

echo ""
echo "-------------------------------------"
echo ""
# cleanup
rm nodes.json

echo "You can filter the nodes by label with the command:"
echo "docker node ls --filter node.label=LABELNAME=VALUE"
echo "(e.g. docker node ls --filter node.label=swarmrole=worker)"
echo ""
echo ""