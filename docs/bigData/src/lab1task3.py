from pyspark import SparkContext, SparkConf
from pathlib import Path


def calcDist(p1: tuple[float, float], p2: tuple[float, float]):
    return ((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2)**0.5


def calcFrechetDist(query_data: list[tuple[float, float]], search_data: list[tuple[float, float]]):
    ca = [[-1 for _ in range(len(search_data))]
          for _ in range(len(query_data))]

    def inner(i, j):
        if ca[i][j] > -1:
            return ca[i][j]
        elif i == 0 and j == 0:
            ca[i][j] = calcDist(query_data[i], search_data[j])
        elif i > 0 and j == 0:
            ca[i][j] = max(inner(i - 1, 0),
                           calcDist(query_data[i], search_data[j]))
        elif i == 0 and j > 0:
            ca[i][j] = max(inner(0, j - 1),
                           calcDist(query_data[i], search_data[j]))
        elif i > 0 and j > 0:
            ca[i][j] = max(min(inner(i - 1, j),
                               inner(i - 1, j - 1),
                               inner(i, j - 1)),
                           calcDist(query_data[i], search_data[j]))
        else:
            ca[i][j] = float("inf")

        return ca[i][j]

    return inner(len(query_data) - 1, len(search_data) - 1)


def textToRecord(text: str):
    tmp = text.split("\r\n")
    tmp = [i.split("\t") for i in tmp]
    tmp = [(float(i[1]), float(i[2])) for i in tmp]
    return tmp


class Record:
    def __init__(self, id: int, posSet: list[tuple[float, float]]):
        self.id = id
        self.posSet = posSet

    def __str__(self):
        return f"traj(id={self.id}, posSet={self.posSet})\n"

    def __lt__(self, other):
        return self.id < other.id

    @staticmethod
    def calcDist(traj1: 'Record', traj2: 'Record'):
        return calcFrechetDist(traj1.posSet, traj2.posSet)


if __name__ == "__main__":
    appName = 'calcDist'
    master = 'local'
    conf = SparkConf().setAppName(appName).setMaster(master)
    sc = SparkContext(conf=conf)

    proj_path = '/Users/shellraining/Documents/learnsth/spark-3.5.0-bin-hadoop3/'

    base_data_path = proj_path + 'hw1.3/BaseTraj/*.txt'
    search_data_path = proj_path + 'hw1.3/QueryTraj/*.txt'

    # read files under base_rdd, and translate every file to a Record, then collect them to a rdd
    base_rdd = sc.wholeTextFiles(base_data_path)\
        .map(lambda x: Record(int(Path(x[0]).stem), textToRecord(x[1][:-2])))\
        .sortBy(lambda x: x)\

    search_rdd = sc.wholeTextFiles(search_data_path)\
        .map(lambda x: Record(int(Path(x[0]).stem), textToRecord(x[1][:-2])))\
        .sortBy(lambda x: x)\

    joined_rdd = base_rdd.cartesian(search_rdd)
    dist_rdd = joined_rdd.map(lambda x: (
        x[1].id, [x[0].id, Record.calcDist(x[0], x[1])]))
    min_dist_rdd = dist_rdd.reduceByKey(
        lambda x, y: x if x[1] < y[1] else y)
    for i in min_dist_rdd.collect():
        print(i)
