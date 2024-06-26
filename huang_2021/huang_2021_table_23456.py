import numpy as np
import pandas as pd
from openpyxl import Workbook
from openpyxl.styles import Font

def get_student_num(df: pd.DataFrame) -> int:
    return len(df.index)

def get_school_num(df: pd.DataFrame) -> int:
    return df['school'].nunique()

def get_variances(df: pd.DataFrame, subject: str, weight="adjusted_weight", group="school", verbose=False) -> float:
    df_weighted_group_mean = df.groupby(group).apply(lambda x: (x[subject]*x[weight]).sum()/x[weight].sum())
    df_weighted_group_mean.name = f"{subject}_{group}_mean"
    df = df.merge(df_weighted_group_mean, on=group)
    df_weighted_overall_mean = (df[subject] * df[weight]).sum() / df[weight].sum()
    
    # Within school variance
    within_variance = (df[weight] * ((df[subject] - df[f"{subject}_{group}_mean"]) ** 2)).sum()

    # Between school variance
    between_variance = (df[weight] * ((df[f"{subject}_{group}_mean"] - df_weighted_overall_mean) ** 2)).sum()

    # Total variance
    total_variance = (df[weight] * ((df[subject] - df_weighted_overall_mean) ** 2)).sum()

    # Percentage of between school variance
    percentage_between_variance = between_variance / (within_variance + between_variance) * 100

    assert total_variance - (within_variance+between_variance) < 0.1
    
    if verbose:
        print("Between groups:\t\t {:.2f}".format(between_variance))
        print("Within groups:\t\t {:.2f}".format(within_variance))
        print("Total:\t\t\t {:.2f}".format(total_variance))
        print("R-square:\t\t {:.2f}%".format(percentage_between_variance, within_variance, between_variance))

    return percentage_between_variance

def export_to_xlsx(data, filename, mark_taiwan=True, sort=True) -> None:
    if sort:
        data = [column_names] + sorted(data, key=lambda x: (x[8] != "N/A", float(x[8].strip('%')) if x[8] != "N/A" else -100), reverse=True)
    else:
        data = [column_names] + data

    wb = Workbook()
    ws = wb.active
    bold_font = Font(bold=True)

    for row_idx, row in enumerate(data):
        for col_idx, value in enumerate(row):
            cell = ws.cell(row=row_idx + 1, column=col_idx + 1)
            cell.value = value

            if mark_taiwan and row[1] == "Chinese Taipei":
                cell.font = bold_font

    wb.save(filename)

def percentage_to_str(percentage:float) -> str:
    if percentage != "N/A":
        percentage = "{:.2f}%".format(percentage)
    return percentage


subjects = ["math", "scie", "read", "soc"]
column_names = ["", "國家", "學生數_九年級", "學生數_十年級", "學校數_九年級", "學校數_十年級", "校間差異占比_九年級", "校間差異占比_十年級", "年級差"]    
column_names += [f"校間差異占比_九年級_PV{i}" for i in range(1, 11)]
column_names += [f"校間差異占比_十年級_PV{i}" for i in range(1, 11)]

if __name__ == "__main__":
    # param
    YEAR = 2022
    COUNTRIES = "all" # 'taiwan' or 'all'
    COUNTRY_LIST = ["Chinese Taipei",
                 "Russia",
                 "Korea",
                 "B-S-J-Z (China)",
                 "Czech Republic",
                 "Slovak Republic",
                 "Bosnia",
                 "Indonesia",
                 "Kosovo",
                 "Croatia",
                 "France",
                 "Belarus",
                 "Brazil",
                 "Albania",
                 "Thailand",
                 "Ukraine",
                 "Morocco",
                 "Kazakhstan",
                 "Israel",
                 "Colombia",
                 "Argentina",
                 "Macao",
                 "Lebanon",
                 "Baku (Azerbaijan)",
                 "Hong Kong",
                 "Mexico",
                 "Qatar",
                 "Uruguay",
                 "Canada",
                 "Panama",
                 "UAE",
                 "Portugal"]
    

    # load data
    # df = pd.read_excel(f"../pisa_{YEAR}/huang_2021_pisa_{YEAR}_data.xlsx", sheet_name="Sheet1")
    print(f"Excel file loaded")

    # result
    results = {subject: list() for subject in subjects}
    taiwan = list()

    if COUNTRIES == "taiwan":
        taiwan_9 = df[(df['country'] == 158) & (df['grade'] == 9)].copy()
        taiwan_9["adjusted_weight"] = taiwan_9["weight"] * get_student_num(taiwan_9) / taiwan_9["weight"].sum()
        print(f"Students: {get_student_num(taiwan_9)}")
        print(f"Schools: {get_school_num(taiwan_9)}")

        get_variances(taiwan_9, "math1", weight="adjusted_weight", verbose=True)

    if COUNTRIES == "all":
        code_country = pd.read_excel(f"../pisa_{YEAR}/pisa_{YEAR}_country.xlsx", sheet_name="Sheet1")
        all_countries = set(code_country['country'])
        for country in COUNTRY_LIST:
            if country not in all_countries:
                print(country)
        exit()
            
        for code, country in zip(code_country['code'], code_country['country']):
            df_country_9 = df[(df['country'] == country) & (df['grade'] == "Grade 9")]
            df_country_10 = df[(df['country'] == country) & (df['grade'] == "Grade 10")]
            if get_student_num(df_country_9) <= 800 or get_student_num(df_country_10) <= 800:
                continue
            
            percentage_9_list = list()
            percentage_10_list = list()
            for subject in [f"{subject_type}{pv}" for subject_type in subjects[:-1] for pv in range(1, 11) ] + [subjects[-1]]:
                df_country_9_subject = df_country_9[df_country_9[subject].notnull()].copy()
                df_country_10_subject = df_country_10[df_country_10[subject].notnull()].copy()
                df_country_9_subject["adjusted_weight"] = df_country_9_subject["weight"] * get_student_num(df_country_9_subject) / df_country_9_subject["weight"].sum()
                df_country_10_subject["adjusted_weight"] = df_country_10_subject["weight"] * get_student_num(df_country_10_subject) / df_country_10_subject["weight"].sum()

                student_9 = get_student_num(df_country_9_subject)
                student_10 = get_student_num(df_country_10_subject)
                school_9 = get_school_num(df_country_9_subject)
                school_10 = get_school_num(df_country_10_subject)

                print(f"Calculating subject {subject} of {country}: {school_9} 9th grade schools, {school_10} 10th grade schools")

                if student_9 > 1:
                    percentage_9 = get_variances(df_country_9_subject, subject)
                    percentage_9_list.append(percentage_9)

                if student_10 > 1:
                    percentage_10 = get_variances(df_country_10_subject, subject)
                    percentage_10_list.append(percentage_10)
                
                # if 'math10', 'read10', 'scie10', or 'soc'
                if subject[-2:] == "10" or subject == "soc":
                    percentage_9_mean = np.mean(percentage_9_list) if percentage_9_list else "N/A"
                    percentage_10_mean = np.mean(percentage_10_list) if percentage_10_list else "N/A"
                    percentage_diff = "N/A" if percentage_9_mean == "N/A" or percentage_10_mean == "N/A" else percentage_10_mean-percentage_9_mean

                    result_subject = list()
                    if subject == "soc":
                        result_subject += [subject, country, student_9, student_10, school_9, school_10]
                        result_subject += [percentage_to_str(percentage_9_mean), percentage_to_str(percentage_10_mean), percentage_to_str(percentage_diff)]
                        results[subject].append(result_subject)
                    else:
                        result_subject += [subject[:-2], country, student_9, student_10, school_9, school_10]
                        result_subject += [percentage_to_str(percentage_9_mean), percentage_to_str(percentage_10_mean), percentage_to_str(percentage_diff)]
                        result_subject += map(percentage_to_str, percentage_9_list+percentage_10_list)
                        results[subject[:-2]].append(result_subject)
                    
                    if country == "Chinese Taipei":
                        taiwan.append(result_subject)

                    percentage_9_list = list()
                    percentage_10_list = list()
                    
        
        export_to_xlsx(taiwan, f"huang_2021_pisa_{YEAR}_table_2.xlsx", mark_taiwan=False, sort=False)
        export_to_xlsx(results['math'], f"huang_2021_pisa_{YEAR}_table_3.xlsx")
        export_to_xlsx(results['scie'], f"huang_2021_pisa_{YEAR}_table_4.xlsx")
        export_to_xlsx(results['read'], f"huang_2021_pisa_{YEAR}_table_5.xlsx")
        export_to_xlsx(results['soc'], f"huang_2021_pisa_{YEAR}_table_6.xlsx")
        
