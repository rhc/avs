#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../model'

class InsightVMApi
  def fetch_cyberark(country)
    credentials = [
      { "account": {}, "description": nil, "hostRestriction": nil, "id": 30, "name": 'CyberArk Ghana', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [802, 99, 803, 1220, 197, 198, 1190, 199, 1191, 968, 234, 1195, 942, 1198, 145, 119, 760, 761, 762, 763, 764, 161, 133, 77] },
      { "account": { "domain": 'mz.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 37, "name": 'CyberArk Mozambique', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [1249, 1250, 1251, 132, 103, 1260, 942, 785, 786, 787, 819, 788, 820, 789, 790, 409, 286, 147, 263, 77] },
      { "account": { "domain": 'zm.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 46,
        "name": 'CyberArk Zambia', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [832, 513, 833, 834, 547, 835, 836, 967, 109, 942, 850, 243, 853, 122, 1050, 1274, 925, 1277, 606, 1278, 831, 77, 63, 143] }, { "account": { "domain": 'ng.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 39,
                                                                                                                                                                                                                                        "name": 'CyberArk Nigeria', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [800, 801, 130, 423, 105, 942, 847, 1263, 432, 848, 1264, 1265, 149, 1273, 264, 77] },
      { "account": { "domain": 'ao.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 28,
        "name": 'CyberArk Angola', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 531, 341, 22, 1175, 408, 1176, 1049, 1177, 26, 27, 1180, 735, 736, 544, 737, 738, 739, 740, 741, 236, 942, 1199, 634, 340, 23, 77] },
      { "account": { "domain": 'mw.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 35,
        "name": 'CyberArk Malawi', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [128, 1248, 609, 1252, 261, 102, 778, 1258, 779, 971, 1259, 780, 781, 942, 815, 816, 146, 136, 77] },
      { "account": { "domain": 'bw.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 27,
        "name": 'CyberArk Botswana', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [37, 1189, 742, 39, 743, 744, 745, 746, 747, 44, 972, 748, 942, 1051, 1181, 1182, 1183, 43, 45, 77, 237] },
      { "account": { "domain": 'ci.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 32,
        "name": 'CyberArk Ivory Coast', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [259, 804, 805, 141, 942, 1200, 1201, 1206, 1207, 282, 765, 766, 767, 77] },
      { "account": { "domain": 'ls.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 34,
        "name": 'CyberArk Lesotho', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [260, 101, 773, 774, 775, 776, 777, 811, 812, 1293, 942, 655, 82, 1202, 1205, 1208, 1211, 127, 607, 135, 77] },
      { "account": { "domain": 'cd.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 29,
        "name": 'CyberArk DRC', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [640, 1185, 258, 1186, 1222, 70, 1193, 1194, 749, 750, 942, 79, 751, 752, 753, 562, 795, 797] },
      { "account": { "domain": 'mu.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 36,
        "name": 'CyberArk Mauritius', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [5, 6, 262, 1159, 9, 430, 942, 782, 783, 1295, 784, 817, 818, 1305, 1306, 419, 137, 77] },
      { "account": { "domain": 'tz.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 44,
        "name": 'CyberArk Tanzania', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [384, 1285, 1286, 265, 395, 849, 851, 151, 346, 608, 808, 809, 810, 107, 813, 942, 814, 178, 379, 1275, 380, 1276, 61, 125, 381, 382, 383, 77] },
      { "account": { "domain": 'zw.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 47,
        "name": 'CyberArk Zimbabwe', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [256, 837, 838, 839, 1287, 840, 1288, 841, 842, 1291, 1292, 110, 942, 1173, 120, 64, 144, 77] },
      { "account": { "domain": 'sbintldirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 31,
        "name": 'CyberArk International', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [901, 843, 844, 1164, 845, 1165, 942, 846, 305, 854, 855, 444, 255, 77] },
      { "account": { "domain": 'na.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 38,
        "name": 'CyberArk Namibia', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [131, 104, 585, 1261, 942, 1262, 148, 822, 791, 823, 1271, 792, 1272, 793, 538, 794, 796, 356, 85, 77] },
      { "account": { "domain": 'ug.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 45,
        "name": 'CyberArk Uganda', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [266, 720, 1296, 1297, 467, 852, 470, 599, 857, 731, 1307, 732, 733, 1311, 292, 297, 298, 108, 494, 942, 561, 563, 821, 439, 824, 825, 826, 124, 828, 829, 830, 291, 293, 295, 296, 426, 299, 459, 300, 77, 301, 142, 115, 152, 858] },
      { "account": { "domain": 'sw.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 43,
        "name": 'CyberArk eSwatini', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [129, 1318, 1319, 106, 942, 1294, 241, 754, 755, 756, 757, 150, 758, 759, 1337, 798, 799, 139, 77] },
      { "account": { "credentialManagement": 'cyberark', "permissionElevation": 'none', "service": 'ssh' }, "description": nil,
        "hostRestriction": nil, "id": 63, "name": 'CyberArk SBICZA01 SSH', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": nil },
      { "account": { "domain": 'ke.sbicdirectory.com', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 33,
        "name": 'CyberArk Kenya', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [320, 768, 321, 769, 770, 771, 772, 1221, 966, 273, 1298, 856, 1242, 1243, 284, 1246, 416, 289, 545, 100, 806, 807, 873, 942, 564, 253, 126, 288, 134, 77, 238, 287] },
      { "account": { "domain": 'SBICZA01', "service": 'cifs' }, "description": nil, "hostRestriction": nil, "id": 25,
        "name": 'CyberArk South Africa SBICZA01', "portRestriction": nil, "siteAssignment": 'specific-sites', "sites": [512, 2, 3, 515, 516, 517, 518, 519, 520, 1033, 521, 522, 12, 525, 526, 527, 528, 529, 530, 532, 533, 534, 535, 536, 537, 1049, 1050, 539, 1051, 540, 29, 541, 30, 542, 31, 543, 546, 548, 549, 550, 48, 566, 567, 568, 569, 570, 1083, 571, 572, 1084, 573, 574, 576, 65, 577, 578, 579, 580, 581, 71, 583, 72, 74, 75, 587, 76, 77, 597, 598, 87, 600, 601, 603, 92, 604, 93, 605, 94, 96, 97, 98, 610, 615, 617, 111, 1137, 625, 630, 632, 633, 642, 1158, 138, 660, 662, 663, 664, 153, 665, 154, 666, 667, 155, 669, 157, 158, 159, 160, 163, 675, 165, 166, 169, 681, 682, 171, 172, 684, 173, 175, 176, 177, 180, 182, 183, 184, 185, 186, 187, 699, 188, 189, 190, 703, 192, 704, 193, 194, 1218, 195, 1219, 196, 204, 205, 206, 207, 208, 210, 211, 724, 213, 725, 216, 217, 218, 219, 220, 221, 734, 222, 1247, 227, 228, 229, 230, 231, 232, 235, 239, 242, 244, 245, 248, 251, 257, 267, 274, 275, 276, 277, 280, 281, 285, 286, 290, 294, 1320, 1321, 1325, 1326, 303, 1327, 1328, 304, 306, 1330, 307, 308, 1332, 309, 1333, 310, 311, 312, 1336, 313, 314, 315, 316, 318, 319, 322, 323, 324, 325, 326, 342, 343, 344, 345, 347, 859, 348, 860, 350, 351, 352, 353, 354, 355, 357, 358, 359, 360, 361, 377, 385, 386, 391, 392, 393, 905, 394, 396, 908, 398, 911, 399, 400, 401, 402, 403, 410, 411, 412, 413, 414, 926, 415, 416, 417, 418, 419, 421, 422, 423, 424, 425, 937, 426, 427, 940, 428, 941, 942, 433, 435, 436, 440, 441, 442, 443, 446, 447, 448, 449, 450, 451, 452, 965, 453, 455, 458, 465, 468, 469, 471, 472, 475, 478, 480, 481, 995, 486, 488, 489, 495, 496, 498, 499, 500, 501, 502, 503, 504, 506, 507, 508, 509, 511, 240, 497, 66, 373, 374, 457, 362, 363, 429, 317, 174] }
    ]
    credentials.find { |credential| credential[:name].include?(country) }
  end

  # Add the site_id to the shared credential sites
  def add_site_shared_credentials(site_id:, credential_id:)
    # retrieve the credential_id
    credential = fetch_shared_credential(credential_id)
    return if credential.sites.include?(site_id)

    credential.sites += [site_id]
    endpoint = "/shared_credentials/#{credential_id}"
    put(endpoint, credential)
  end

  def fetch_shared_credentials
    fetch_all('/shared_credentials') do |resource|
      yield SharedCredential.from_json(resource)
    end
  end

  def fetch_shared_credential(id)
    fetch("/shared_credentials/#{id}") do |data|
      SharedCredential.from_json(data)
    end
  end
end
