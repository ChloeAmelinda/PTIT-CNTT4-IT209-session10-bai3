# Session 10 - EX3: Multi-stage Docker Build

## 1. Muc tieu
Su dung Multi-stage Build va Docker layer cache de dong goi REST API Node.js/Express, so sanh voi Single-stage.

## 2. Cau truc thu muc
```text
ex3/
├── Dockerfile
├── Dockerfile.single
├── package.json
├── server.js
├── .dockerignore
└── README.md
```

## 3. Cach build
```powershell
docker build -f Dockerfile.single -t hw-backend:single .
docker build -t hw-backend:multistage .
```

## 4. Bang so sanh thuc te
| Tieu chi | Single-stage | Multi-stage |
|---|---:|---:|
| Dung luong image | 196 MB | 186 MB |
| So filesystem layer | 8 | [DIEN KET QUA] |
| So giai doan build | 1 | 2 |
| Ghi chu | Cai dat thu vien trong image | Cai dat o builder, copy can thiet sang runtime |

Ty le giam dung luong = (196 - 186) / 196 x 100 = **5,10%** (tiet kiem 10 MB).

**Danh gia:** Hai image da build thanh cong va Multi-stage nho hon, nhung chua dat muc tieu duoi 100 MB va giam 50-70% cua de bai. Ca hai dung Node 18 Alpine lam base runtime; do do muc giam bi gioi han. Multi-stage giup tach build dependencies va runtime, nhung khong tu dong dam bao dung luong giam manh.

## 5. Cach kiem tra
```powershell
docker image ls hw-backend
(docker image inspect hw-backend:single | ConvertFrom-Json).RootFS.Layers.Count
(docker image inspect hw-backend:multistage | ConvertFrom-Json).RootFS.Layers.Count
docker run -d --name app-multistage -p 8081:3000 hw-backend:multistage
docker ps
docker logs app-multistage
curl.exe -i http://localhost:8081/
```

**Ket qua API:** [DIEN HTTP STATUS THUC TE, vi du HTTP/1.1 200 OK neu da kiem tra]

**Ghi chu cong:** Su dung 8081 o may host do cong 8080 dang bi AgentService su dung; cong trong container van la 3000.

## 6. Layer caching
Sao chep `package*.json` truoc va cai dat dependencies truoc khi `COPY server.js` giup Docker tai su dung cache dependency layer khi chi sua ma nguon (mien la dependency files khong thay doi).

## 7. Ket luan
Dockerfile Multi-stage tach giai doan builder va runtime, de quan ly artifact va phu thuoc can thiet. Ket qua benchmark phai dua tren output cua Docker tren may thuc te.
