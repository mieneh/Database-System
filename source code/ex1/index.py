fread = open("input.txt", "r")
count = 0
table = ""

tableName = ""
 
listTable = dict()

for x in fread:
    if(('{'   in x )  or ('}'  in x) or ("]," in x)):
        continue
    if("Entity" in x):
        count = 2
        continue

    if("Relationship" in x):
        count = 1
        table += "----- Mỗi quan hệ giữa các thực thể -----\n\n"
        continue

    if(count == 1):
        table = table + "\t" + x.strip().replace("\"","").replace("'","") + "\n"

    if(count == 2):
        data = x.strip().replace("\n", "")
        tableName = data[(data.find("\"")+1):(data.rfind("\""))]
        listItemTable = data[(data.find("[")+1):(data.rfind("]"))]
        listItemTable = listItemTable.split(", ")
        listTable[tableName] = listItemTable

    if(count == 1):
        data = x.strip()
        relationShip = data[(data.find("<")+1):(data.find(">"))]
        tableName_1 = data[(data.find("\"")+1):(data.rfind("\""))]
        tableName_2 = data[(data.find("'")+1):(data.rfind("'"))]

        if("ChaCon" in relationShip):
            for i in listTable[tableName_2]:
                if("PK_" in i):
                    i =  "FK_" + i + " references " + tableName_2 + "("+ i+ ")"
                    listTable.setdefault(tableName_1, []).append(i)
                    break
        elif("DaTri" in relationShip):
            for i in listTable[tableName_2]:
                if("PK_" in i):
                    i =  "FK_" + i + " references " + tableName_2 + "("+ i + ")"
                    listTable.setdefault(relationShip, []).append(i)
                    break
        else:
            quanHe_1 = data[(data.find("(")+1):(data.find(")"))]
            quanHe_2 = data[(data.rfind("(")+1):(data.rfind(")"))]
            if("1,n" in quanHe_1 and "1,1" in quanHe_2):
                for k in listTable[tableName_2]:
                    x = k.replace("PK", "FK") +  " references " + tableName_2 + "("+ k+ ")"
                    listTable.setdefault(tableName_1, []).append(x)
                    break
            elif("1,n" in quanHe_2 and "1,1" in quanHe_1):
                for k in listTable[tableName_1]:
                    if("PK" in k):
                        x = k.replace("PK", "FK") +  " references " + tableName_1 + "("+ k+ ")"
                        listTable.setdefault(tableName_2, []).append(x)
                        break
            elif("1,1" in quanHe_2 and "1,1" in quanHe_1):
                for k in listTable[tableName_2]:
                    if("PK" in k):
                        x = k.replace("PK", "FK") +  " references " + tableName_2 + "("+ k+ ")"
                        listTable.setdefault(tableName_1, []).append(x)
                        break
            elif("1,n" in quanHe_2 and "1,n" in quanHe_1):
                for k in listTable[tableName_2]:
                    if("PK" in k):
                        x = "FK_" + k +  " references " + tableName_2 + "("+ k+ ")"
                        listTable.setdefault(relationShip, []).append(x)
                        break
                for k in listTable[tableName_1]:
                    if("PK" in k):
                        x = "FK_" + k +  " references " + tableName_1 + "("+ k+ ")"
                        listTable.setdefault(relationShip, []).append(x)
                        break

table = table.replace("]", "")

table += "\n----- Danh sách bảng của các thực thể -----\n\n"

for x in listTable:
    if x == "":
        continue
    table += "\tBảng " + x + ":"
    for y in range(len(listTable[x])-1):
        if(listTable[x][y] == ''):
            continue
        table  = table + "\n\t\t" + listTable[x][y]
    table = table + "\n\t\t" + listTable[x][len(listTable[x])-1] + "\n\n"
with open('output.txt', 'w', encoding='utf-8') as f:
    f.write(table)

fread.close()
f.close()