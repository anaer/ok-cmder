import sys
import os

def social_insurance_funds(base):
    p_yanglao_rate = 0.08
    p_yiliao_rate = 0.02
    p_shiye_rate = 0.002
    p_shengyu_rate = 0
    p_gongshang_rate = 0

    social_in = base * (p_yanglao_rate + p_yiliao_rate + p_shiye_rate
            + p_shengyu_rate + p_gongshang_rate)

    return social_in

def main():
	if len(sys.argv) == 2:
		out_of_salary = 0
	if len(sys.argv) == 3:
		out_of_salary = int(sys.argv[2])
	salary = int(sys.argv[1])
	
	max_base = 23118
	personal_income_tax_base = 5000 
	
	if salary > max_base:
		social_insurance = social_insurance_funds(max_base)
		reserved_funds = max_base * 0.12
	else:
		social_insurance = social_insurance_funds(salary)
		reserved_funds = salary * 0.12
	print("social_insurance: %0.2f" % social_insurance)
	print("reserved_funds: %0.2f" % reserved_funds)
	
	income_tax_base = salary - social_insurance - reserved_funds - personal_income_tax_base + out_of_salary
	#print("income_tax_base: %0.2f" % income_tax_base)
	if (income_tax_base < 3000):
		personal_income_tax = income_tax_base * 3 / 100
	elif (income_tax_base >= 3000 and income_tax_base < 12000):
		personal_income_tax = income_tax_base * 10 / 100 - 210
	elif (income_tax_base >= 12000 and income_tax_base < 25000):
		personal_income_tax = income_tax_base * 20 / 100 - 1410
	elif (income_tax_base >= 25000 and income_tax_base < 35000):
		personal_income_tax = income_tax_base * 25 / 100 - 2660
	elif (income_tax_base >= 35000  and income_tax_base < 55000):
		personal_income_tax = income_tax_base * 30 / 100 - 4410 
	elif (income_tax_base >= 55000 and income_tax_base < 80000):
		personal_income_tax = income_tax_base * 35 / 100 - 7160 
	elif (income_tax_base >= 80000):
		personal_income_tax = income_tax_base * 45 / 100 - 15160 
	print("personal_income_tax: %0.2f" % personal_income_tax)
	
	personal_income = salary - personal_income_tax - social_insurance - reserved_funds + out_of_salary
	
	print("personal_income: %0.2f" % personal_income)

if __name__ == "__main__":
	main()
