#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'model'

class InsightVMApi
  def fetch_scan_engine_pools
    fetch_all('/scan_engine_pools') do |resource|
      yield ScanEnginePool.from_json(resource)
    end
  end

  def fetch_scan_engines
    fetch_all('/scan_engines') do |resource|
      yield ScanEngine.from_json(resource)
    end
  end

  def all_scan_engines
    engines = []
    fetch_scan_engines do |e|
      engines << e
    end
    engines
  end

  # return scan engines that went from up to down
  # given the previous status in a hash
  # if the previous status is not known, assume it was up
  #
  def scan_engines_from_up_to_down(engines, previous_status)
    downs = engines.select(&:down?).reject(&:rapid7_hosted?)
    downs.select do |site|
      status = previous_status[site.id]
      status.nil? ? true : status
    end
  end

  def engine_last_status_from(csv_file)
    result = {}
    csv_data = CSV.read(csv_file, headers: true)
    sorted_data = csv_data.sort_by { |row| row['timestamp'] }

    sorted_data.each do |row|
      engine_id = row['engine_id'].to_i
      status = row['up'] == 'true'
      result[engine_id] = status
    end
    result
  end

  # append the new engine status in the csv_file
  # only if it is different from the previous status
  def append_new_status(engines:, csv_file:, previous_status:)
    CSV.open(csv_file, 'a') do |csv|
      engines.each do |engine|
        next if previous_status[engine.id] == engine.up?

        csv << [Time.now.strftime('%Y-%m-%dT%H:%M'), engine.id, engine.up?.to_s]
      end
    end
  end

  # TODO: rename Swaziland to eSwatini
  # TODO fetch pools from API
  def fetch_country_scan_engine_pools(country)
    pools = [
      { "id": 31, "name": 'DRC Core Network Scanners', "engines": [32, 145],
        "sites": [640, 258, 1222, 70, 904, 1097, 1225, 78, 79, 1040, 1107, 406, 920, 795, 412, 797, 1185, 1058, 1188, 997, 1192, 1193, 1194, 491, 749, 750, 942, 751, 752, 753, 562, 1144] },
      { "id": 19, "name": 'Ghana Core Network Scanners', "engines": [16, 22],
        "sites": [1220, 133, 197, 198, 199, 1227, 1163, 463, 1039, 80, 145, 405, 1111, 984, 920, 414, 990, 802, 99, 803, 1190, 551, 999, 1127, 234, 1066, 1195, 492, 1196, 1197, 1198, 942, 1199, 560, 1072, 1010, 1014, 119, 760, 761, 1017, 762, 1082, 763, 764, 1023] },
      { "id": 88, "name": 'Jersey Core Network Scanners', "engines": [147],
        "sites": [843, 844, 1164, 845, 1165, 846, 255] },
      { "id": 59, "name": 'Mozambique Core Network Scanners', "engines": [113, 97],
        "sites": [132, 263, 1099, 1163, 721, 785, 1233, 786, 147, 787, 84, 788, 789, 790, 920, 409, 1249, 1251, 421, 1253, 1254, 103, 1255, 1260, 942, 1199, 819, 820, 950, 954] },
      { "id": 41, "name": 'Zimbabwe Core Network Scanners', "engines": [40],
        "sites": [64, 837, 838, 839, 1095, 1287, 1288, 841, 1289, 842, 1290, 1291, 1163, 1292, 144, 1173, 1241, 990, 1002, 428, 110, 116, 120, 1082, 959] },
      { "id": 18, "name": 'Malawi Core Network Scanners', "engines": [92],
        "sites": [128, 960, 261, 903, 136, 1032, 778, 779, 971, 1163, 780, 781, 1231, 464, 146, 83, 1171, 920, 1305, 1052, 1054, 990, 992, 1248, 609, 418, 1060, 869, 1253, 102, 1000, 1128, 1256, 1065, 1257, 1258, 1259, 1132, 942, 815, 816, 883, 1011, 887, 1082] },
      { "id": 77, "name": 'Uganda Core Network Scanners', "engines": [134, 149, 69],
        "sites": [1025, 266, 459, 142, 1038, 720, 1296, 852, 470, 599, 1239, 152, 1112, 920, 857, 858, 731, 1307, 1308, 1053, 1309, 1310, 990, 1311, 1056, 1312, 296, 108, 300, 1069, 494, 942, 1199, 561, 821, 439, 824, 1016, 953, 826, 1018, 124, 828, 1020, 829] },
      { "id": 29, "name": 'Mauritius Core Network Scanners', "engines": [93],
        "sites": [4, 5, 6, 262, 1159, 9, 137, 1163, 1101, 782, 783, 1295, 784, 1232, 1170, 1302, 1303, 920, 1305, 1306, 990, 419, 430, 1199, 817, 818, 1082] },
      { "id": 127, "name": 'International (London, Beijing...) Core Network Scanners', "engines": [121],
        "sites": [912, 305, 854, 855, 444, 479] },
      { "id": 52, "name": 'Angola Core Network Scanners', "engines": [95],
        "sites": [1163, 1298, 531, 1299, 22, 1174, 23, 1175, 408, 920, 1049, 1177, 26, 410, 1178, 27, 1179, 1180, 1311, 544, 942, 1199, 1077, 1082, 1223, 327, 328, 1096, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 990, 735, 736, 737, 738, 739, 740, 996, 741, 490, 634] },
      { "id": 36, "name": 'Zambia Core Network Scanners', "engines": [79],
        "sites": [1280, 513, 1281, 1283, 902, 1163, 143, 1041, 920, 1050, 925, 547, 1059, 420, 1064, 427, 942, 945, 1076, 181, 63, 831, 832, 833, 834, 835, 1091, 836, 967, 201, 850, 1108, 853, 1240, 474, 986, 606, 994, 1001, 364, 109, 114, 243, 885, 886, 122, 1274, 1277, 1278, 1279] },
      { "id": 72, "name": 'Lesotho Core Network Scanners', "engines": [70],
        "sites": [962, 260, 773, 1093, 774, 135, 775, 776, 777, 461, 1230, 655, 82, 607, 417, 101, 487, 811, 812, 1202, 1208, 1209, 1210, 1211, 127] },
      { "id": 26, "name": 'Swaziland Core Network Scanners', "engines": [20],
        "sites": [129, 1094, 139, 1163, 460, 1294, 1237, 150, 920, 798, 990, 799, 1315, 1316, 998, 1318, 871, 1319, 424, 106, 876, 942, 1199, 112, 241, 754, 755, 947, 756, 884, 757, 758, 759, 1079, 1082] },
      { "id": 26, "name": 'Eswatini Core Network Scanners', "engines": [20],
        "sites": [129, 1094, 139, 1163, 460, 1294, 1237, 150, 920, 798, 990, 799, 1315, 1316, 998, 1318, 871, 1319, 424, 106, 876, 942, 1199, 112, 241, 754, 755, 947, 756, 884, 757, 758, 759, 1079, 1082] },
      { "id": 48, "name": 'Kenya Core Network Scanners', "engines": [106],
        "sites": [768, 769, 514, 770, 771, 772, 1092, 1221, 1029, 966, 1160, 1161, 651, 1229, 654, 81, 1105, 1043, 404, 920, 1243, 1244, 284, 1245, 1118, 1246, 287, 416, 288, 289, 545, 100, 806, 807, 873, 1129, 1004, 238, 1071, 564, 1141, 952, 505, 253, 126] },
      { "id": 76, "name": 'Botswana Core Network Scanners', "engines": [75, 74],
        "sites": [1028, 1224, 972, 1100, 983, 920, 665, 1113, 411, 987, 1051, 1181, 991, 1183, 1184, 1187, 37, 1061, 1189, 742, 870, 39, 743, 744, 872, 745, 746, 43, 747, 875, 1003, 44, 748, 45, 237, 877, 944, 882, 1075] },
      { "id": 73, "name": 'Ivory Coast Core Network Scanners', "engines": [146],
        "sites": [259, 804, 805, 1098, 1228, 141, 1200, 1201, 1203, 1172, 1204, 117, 1206, 407, 1207, 282, 765, 766, 415, 767] },
      { "id": 84, "name": 'Nigeria Core Network Scanners', "engines": [82, 83],
        "sites": [800, 801, 130, 1157, 423, 264, 105, 1102, 942, 847, 1263, 848, 432, 1265, 946, 1235, 1267, 1268, 149, 86, 920, 1273, 1086] },
      { "id": 12, "name": 'South Africa Core Network Scanners', "engines": [8, 14, 9, 13, 91, 11, 7, 6],
        "sites": [515, 516, 517, 520, 525, 526, 527, 528, 529, 530, 532, 533, 534, 535, 537, 539, 540, 541, 286, 542, 543, 548, 549, 550, 1320, 1321, 1322, 1323, 1324, 1325, 1326, 1327, 48, 304, 1328, 1329, 1330, 307, 1331, 1332, 1333, 1334, 567, 1335, 568, 570, 571, 572, 573, 574, 576, 65, 577, 578, 66, 579, 583, 74, 587, 594, 597, 598, 1110, 87, 600, 601, 604, 349, 353, 610, 612, 613, 615, 360, 616, 617, 618, 620, 1135, 624, 1138, 1139, 1140, 629, 630, 632, 633, 642, 1156, 1162, 1163, 1166, 658, 662, 663, 664, 920, 666, 667, 668, 669, 413, 670, 671, 927, 673, 675, 676, 677, 678, 679, 169, 681, 682, 683, 684, 686, 942, 433, 689, 690, 436, 692, 440, 441, 186, 187, 699, 188, 1212, 1213, 189, 190, 703, 1215, 704, 1216, 1217, 195, 196, 205, 206, 465, 212, 213, 216, 728, 729, 218, 730, 219, 220, 222, 478, 990, 1247, 480, 228, 229, 230, 231, 488, 235, 242, 500, 245, 504, 506, 507, 509, 511] },
      { "id": 123, "name": 'Namibia Core Network Scanners', "engines": [122],
        "sites": [1089, 131, 585, 586, 1037, 657, 1234, 148, 85, 791, 792, 793, 538, 989, 422, 1062, 104, 552, 1005, 1261, 1266, 948, 1012, 822, 1270, 823, 1271, 1272, 639] },
      { "id": 39, "name": 'Tanzania Core Network Scanners', "engines": [38, 44],
        "sites": [384, 1024, 1026, 1282, 1284, 1285, 1286, 265, 395, 652, 462, 849, 851, 659, 596, 1238, 151, 985, 608, 808, 425, 809, 810, 107, 1067, 493, 1006, 113, 1009, 1015, 379, 1019, 1275, 380, 61, 125, 381, 382, 510, 1022, 383, 1087] }
    ]
    pools.find { |pool| pool[:name].downcase.include?(country.downcase) }
  end

  def add_site_scan_engine_pool(site_id:, pool_id:)
    # retrieve the credential_id
    pool = fetch_scan_engine_pool(pool_id)
    return if pool.sites.include?(site_id)

    pool.sites += [site_id]
    endpoint = "/scan_engine_pool/#{pool_id}"
    put(endpoint, pool)
  end
end
