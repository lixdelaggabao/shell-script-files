#!/bin/bash
# Student name and number: Lixdel Louisse L. Aggabao (041081985)
# Course code and lab section number: CST8102 - 313
# Description: This script calculates the Body Mass Index (BMI) based on the inputted height and weight and then determines the BMI category.
# Algorithm:
# 1. Prompt the user to enter height (m).
# 2. Prompt the user to enter weight (kg).
# 3. Calculate the BMI using the formula: BMI = weight / (height * height).
# 4. Determine the BMI category using: BMI < 18.5: Underweight, 18.5 <= BMI < 25: Normal weight, 25 <= BMI < 30: Overweight, BMI >= 30: Obesity.
# 5. Display the calculated BMI and its category.

# Clear the screen
clear

# Prompt the user for height and weight input
read -p "Enter your height in m: " height
read -p "Enter your weight in kg: " weight

# Calculate BMI
bmi=$(echo "scale=2; $weight / ($height * $height)" | bc)

# Determine BMI category
if (( $(echo "$bmi < 18.5" | bc -l) ))
then
	category="Underweight"
elif (( $(echo "$bmi >= 18.5 && $bmi < 25" | bc -l) ))
then
	category="Normal weight"
elif (( $(echo "$bmi >= 25 && $bmi < 30" | bc -l) ))
then
	category="Overweight"
else
	category="Obesity"
fi

# Display BMI and its category
echo "Your BMI is: $bmi"
echo "Category: $category"
