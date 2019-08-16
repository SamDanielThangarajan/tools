#!/usr/bin/env bash

cost=$1
avgift=$2
run_cost=0

[[ $# -eq 3 ]] && run_cost=$3

loan_amount=`echo "$cost * 0.85" | bc`
intrest=`echo "$loan_amount * 0.015" | bc`
mortgage=`echo "$loan_amount * 0.02" | bc`

mortgage_per_month=`echo "$mortgage / 12" | bc`
total_yr=`echo "$intrest + $mortgage" | bc`
total_mn=`echo "$total_yr / 12" | bc`

exp_p_month=`echo "$total_mn + $avgift" |bc`

exp_with_no_mort=`echo "$exp_p_month - $mortgage_per_month" | bc`

echo "Loan amount : $loan_amount"

echo "yr Expense (Bank): $total_yr"
echo "Mon Exp (Bank): $total_mn"

echo "Mortgae : $mortgage_per_month" 

echo "Exp per month (Total) : $exp_p_month"
echo "Exp (without mortage) : $exp_with_no_mort" 

