---
title: 对一个指定 txt 文本进行排序
tag:
  - script
description: 大数据课程中遇到的一个问题
---

# {{ $frontmatter.title }}

遇到了这样类型的一个 txt 文件,需要对其中 `query_index` 字段进行排序:

```txt
{'query_index': 24, 'base_path_index': '152', 'min_distance': 0.009709580318146551}
{'query_index': 16, 'base_path_index': '44', 'min_distance': 0.026497587446597026}
{'query_index': 4, 'base_path_index': '168', 'min_distance': 0.018007449145665034}
{'query_index': 20, 'base_path_index': '3', 'min_distance': 0.009509082187575596}
{'query_index': 12, 'base_path_index': '61', 'min_distance': 0.016400024322089767}
{'query_index': 28, 'base_path_index': '130', 'min_distance': 0.04006611880491308}
```

使用到的脚本如下:

```python
with open('./task3_output.txt', 'r') as file:
    data = file.readlines()

# 将每一行的数据解析为字典
parsed_data = [eval(line.strip()) for line in data]

# 按照query_index的值进行排序
sorted_data = sorted(parsed_data, key=lambda x: x['query_index'])

# 输出排序后的数据
for item in sorted_data:
    print(item)
```
