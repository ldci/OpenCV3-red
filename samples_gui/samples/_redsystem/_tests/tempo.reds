b: as byte! image/6
if (b = #"R") [iplImage/colorModel: "RGBA"]
if (b = #"G") [iplImage/colorModel: "GRAY"]
b: as byte! image/7

if (b = #"B") [iplImage/channelSeq: "BGRA"]
if (b = #"R") [iplImage/channelSeq: "RGBA"]
if (b = #"G") [iplImage/channelSeq: "GRAY"]
iplImage/dataOrder: image/8
iplImage/origin: image/9
iplImage/align: image/10
iplImage/width: image/11
iplImage/height: image/12
iplImage/*roi: as IplRoi! image/13
iplImage/*maskROI: as byte-ptr! image/14
iplImage/*imageId: as byte-ptr! image/15
iplImage/*tileInfo: as byte-ptr! image/16
iplImage/imageSize: image/17
iplImage/*imageData: image/18
iplImage/widthStep: image/19
iplImage/bm0: image/20
iplImage/bm1: image/21
iplImage/bm2: image/22
iplImage/bm3: image/23
iplImage/bc0: image/24
iplImage/bc1: image/25
iplImage/bc2: image/26
iplImage/bc3: image/27
iplImage/*imageDataOrigin: as byte-ptr! image/28