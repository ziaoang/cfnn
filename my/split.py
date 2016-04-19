import random


n = 6040
m = 3952


mat = []
for i in range(n):
    tmp = []
    for j in range(m):
        tmp.append(0)
    mat.append(tmp)


train = []
test  = []
for line in open("../data/movieLens/ratings-1M.dat"):
    t = line.strip().split("::")
    userId = int(t[0]) - 1
    itemId = int(t[1]) - 1
    rating = int(t[2])

    if random.random() < 0.9:
        mat[userId][itemId] = rating
        train.append([userId, itemId, rating])
    else:
        test.append([userId, itemId, rating])


user = []
for i in range(n):
    t = []
    for j in range(m):
        if mat[i][j] > 0:
            t.append("%d:%d"%(j, mat[i][j]))
    user.append(" ".join(t))


item = []
for i in range(m):
    t = []
    for j in range(n):
        if mat[j][i] > 0:
            t.append("%d:%d"%(j+m, mat[j][i]))
    item.append(" ".join(t))


df = open("train.txt", "w")
for t in train:
    i = t[0]
    j = t[1]
    r = t[2]
    filter_user = (" " + user[i] + " ").replace(" %d:%d "%(j, r), " ").strip()
    filter_item = (" " + item[j] + " ").replace(" %d:%d "%(i+m, r), " ").strip()
    df.write("%s %s #%d.%d.%d\n"%(filter_user, filter_item, i, j, r))
df.close()


df = open("test.txt", "w")
for t in test:
    i = t[0]
    j = t[1]
    r = t[2]
    filter_user = (" " + user[i] + " ").replace(" %d:%d "%(j, r), " ").strip()
    filter_item = (" " + item[j] + " ").replace(" %d:%d "%(i+m, r), " ").strip()
    if filter_user == "" and filter_item == "":
        print("ERROR: no information for user %d item %d"%(i, j))
    else:
        df.write("%s %s #%d.%d.%d\n"%(filter_user, filter_item, i, j, r))
df.close()









