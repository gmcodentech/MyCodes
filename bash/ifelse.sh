#! /bin/bash
read -p "Enter age: " age
if [ $age -gt 18 ]; then
	echo "adult"
else
	echo "young"
fi