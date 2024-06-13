fread = open("input.txt", "r")
count = -1

listHamPhuThuoc = []
listHamPhuThuocTEMP = []

def checkAll(listHamPhuThuoc):
    for i in listHamPhuThuoc:
        if(i.check):
            return True
    return False

def checkContains(listDich, listBaoDong):
    for i in listDich:
        if( i  in listBaoDong):
            continue
        else:
            return False
    return True

class HamPhuThuoc:

    def __init__(self, listDich, listNguon, check):
        self.listDich = listDich
        self.listNguon = listNguon
        self.check = check

    def updateCheck(self,check):
        self.check = check

countObj = 0

U = []
listTapNguon = []
listTapDich = []

for x in fread:

    if("Table" in x):
        count = 0
        continue

    if("Dependencies" in x):
        count = 1
        continue

    if(count == 0):
        data = x.strip()
        tempU  = data[(data.find("[")+1):(data.find("]"))]
        if("," in data):
            tempU = tempU.split(", ")
            U = U + tempU
        else:
            U.append(tempU)

    if(count == 1):        
        data = x.strip()
        listDich  = data[(data.find("(")+1):(data.find(")"))]
        listNguon  = data[(data.find("[")+1):(data.find("]"))]
        tempDich = list()
        if("," in listDich):
            data = listDich.split(", ")
            tempDich = list()
            for i in data:
                tempDich.append(i)
        else:
            tempDich.append(listDich)
        tempNguon = list()
        if("," in listNguon):
            data = listNguon.split(", ")
            tempNguon = list()
            for i in data:
                tempNguon.append(i)
        else:
            tempNguon.append(listNguon)
        
        listTapNguon = listTapNguon + tempNguon
        listTapDich = listTapDich + tempDich
        listHamPhuThuoc.append(HamPhuThuoc(tempDich, tempNguon, True))
        listHamPhuThuocTEMP.append(HamPhuThuoc(tempDich, tempNguon, True))

U = list(set(U))
listTapNguon = list(set(listTapNguon))
listTapDich = list(set(listTapDich))

listTapNguon = list(set(U) ^ set(listTapNguon))
listTapDich = list(set(U) ^ set(listTapDich))
listL = list(set(U) ^ set(listTapNguon) ^ set(listTapDich))

def setCheck(listHamPhuThuoc):
    for i in range(len(listHamPhuThuoc)):
        print(listHamPhuThuoc[i].check)
        listHamPhuThuoc[i].updateCheck(True)
        print(listHamPhuThuoc[i].check)

def FindBaoDong(Xxsa, listHamPhuThuoc):
    ketQuaCuaBaoDong = Xxsa
    check = True
    while checkAll(listHamPhuThuoc) and check:
        tempCheck = True
        for i in range(len(listHamPhuThuoc)):
            if(listHamPhuThuoc[i].check):
                if( (len(listHamPhuThuoc[i].listDich) == 1) and (listHamPhuThuoc[i].listDich[0] in ketQuaCuaBaoDong)):
                    ketQuaCuaBaoDong = ketQuaCuaBaoDong + listHamPhuThuoc[i].listNguon
                    listHamPhuThuoc[i].updateCheck(False)
                    tempCheck = False
                if((len(listHamPhuThuoc[i].listDich) > 1) and checkContains(listHamPhuThuoc[i].listDich,ketQuaCuaBaoDong)):
                    ketQuaCuaBaoDong = ketQuaCuaBaoDong + listHamPhuThuoc[i].listNguon
                    listHamPhuThuoc[i].updateCheck(False)
                    tempCheck = False
        if(tempCheck):
            check = False
    
    return list(set(ketQuaCuaBaoDong))

def findKhoa(listTapNguon, U, listL, listHamPhuThuoc):
    baoDong2 = FindBaoDong(listTapNguon, listHamPhuThuoc)
    if(len(baoDong2) == len(U)):
        return listTapNguon
    listKhoa = []
    for i in listL:
        tempNguon = listTapNguon
        tempNguon.append(i)
        baodong2 = FindBaoDong(tempNguon, listHamPhuThuoc)
        if(len(baodong2) == len(U)):
            listKhoa.append(tempNguon)
    return list(set(listKhoa))

print("Nhập tập thuộc tính X cần bao đóng (Ví dụ: 'PK_MaKH PK_MaPP'): ")
baoDong1 = input()
baoDong1 = list(baoDong1.split(" "))
result  = FindBaoDong(baoDong1, listHamPhuThuocTEMP)

xBaoDong = ""
for i in baoDong1:
    xBaoDong = xBaoDong + " -- " + i
baoDongFile = "Bao đóng tập thuộc tính X (" + xBaoDong + ") là: \n"
for i in set(result):
    baoDongFile =  baoDongFile + "\t" + i + "\n"

resultKhoa = findKhoa(listTapNguon, U, listL, listHamPhuThuoc)
khoa = "{"
for i in resultKhoa:
    khoa = khoa + i + " "
khoa = khoa + "}"

baoDongFile = baoDongFile + "\n" + "Lược đồ có các khóa là: \n"
baoDongFile = baoDongFile + "\t" + khoa

with open('output.txt', 'w', encoding='utf-8') as f:
    f.write(baoDongFile)
fread.close()
f.close()