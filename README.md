## OpenBMC on AST2600 with QEMU


 > **實驗目標**: 構建ast2600開發版鏡像，在qemu上面開啟
 
 > **實驗器材**:只需要有一台linux主機，或是windows 開啟wsl2 功能


### 1. 建立目錄
```bash
mkdir -p AST2600_qemu
```

### 2. 安裝 Docker
```bash!
git clone https://github.com/macchen-yu/ast2600.git 
sudo sh ./ast2600/docker_install.sh
```

### 3. 下載 OpenBMC 原始碼
```bash
git clone https://github.com/AspeedTech-BMC/openbmc.git
```

### 4. 進入專案目錄並設定環境
```bash
cd asbmc_v9.5/openbmc/
. setup ast2600-default as26_build
```

### 5. 編譯 OpenBMC 映像檔（需要較長時間）
**注意**: 伺服器記憶體需超過 **32GB**
```bash
bitbake obmc-phosphor-image
```
:::danger
如果記憶體不足，可以嘗試調整 <build 目錄>/conf/local.conf 中的 BB_NUMBER_THREADS 參數，以控制構建鏡像時的記憶體使用量。
:::

---

### 6. 安裝 QEMU
```bash
sudo apt install qemu-system qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virt-manager -y
```

### 7. 進入編譯目錄
```bash
cd ~/asbmc_v9.5/openbmc/as26_build
```

### 8. 查詢可用機器
```bash
qemu-system-arm -machine help
```

### 9. 啟動 QEMU 模擬 AST2600
> **注意**: `obmc-phosphor-image-ast2600-default-<時間戳>.static.mtd` 的名稱每次都不同，需依照實際生成的檔案名稱修改。
```bash
./qemu-system-arm -m 1024 -M ast2600-evb -nographic \
  -drive file=./obmc-phosphor-image-ast2600-default.static.mtd,format=raw,if=mtd \
  -net nic -net user,hostfwd=tcp:192.168.31.6:2222-:22,hostfwd=tcp:192.168.31.6:2443-:443,hostfwd=udp:192.168.31.6:2623-:623,hostname=qemu
```

### 10. 登入 OpenBMC
```bash
用戶名: root
密碼: 0penBmc
```
[開啟影片連結](https://drive.google.com/file/d/1c0XYjPUL9SaXHf-o9XrfRtcRBCrru_TW/view?usp=sharing)

### 登入webbmc網頁
在瀏覽器輸入
https://192.168.31.6:2443
![image](https://hackmd.io/_uploads/BJ1s3DKoke.png)



### 11. 退出 QEMU
```bash
ps aux | grep qemu
kill -9 <PID>
```

