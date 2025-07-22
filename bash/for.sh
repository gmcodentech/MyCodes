#!/bin/bash
read -p "Enter a number: " no
total=0

for ((i=1; i<=no; i++)); do
  total=$((total + i))
done

echo "Total is $total"
