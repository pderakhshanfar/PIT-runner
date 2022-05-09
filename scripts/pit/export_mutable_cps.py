from sys import argv
import os

allCPs=argv[1]
project_name=argv[2]

arrCP=allCPs.split(":")

dir_path = os.path.dirname(os.path.realpath(__file__))
cwd = os.getcwd()
finalResult=""

for cp in arrCP:
    preparedCPDir=os.path.join(cwd,cp)
    if "projects/"+project_name in cp:
        finalResult=finalResult+preparedCPDir+","
    # if cp.startswith("projects"):
    #     finalResult=finalResult+preparedCPDir+","
    # elif cp.endswith(".jar") and not cp.startswith("libs/"):
    #     finalResult=finalResult+preparedCPDir+","


print finalResult[:-1]
