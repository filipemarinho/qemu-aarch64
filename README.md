# qemu-aarch64
Emulação com o QEMU 4.2.0 para ARM 64 bits e alguns programas em assembly. 

Host: Linux Ubuntu 5.4.0-33-generic #37-Ubuntu SMP x86_64 GNU/Linux

Guest: Linux debian 4.9.0-12-arm64 #1 SMP Debian 4.9.210-1  aarch64 GNU/Linux


Baseado [nesse post](https://translatedcode.wordpress.com/2017/07/24/installing-debian-on-qemus-64-bit-arm-virt-board/)

Compilei o binário da versão 4.2.0 do site oficial do qemu.



# Instruções para emular
## create img:
```
qemu-img create -f qcow2 hda.qcow2 5G
```

### install:
```
~/qemu/qemu-4.2.0/aarch64-softmmu/qemu-system-aarch64 -M virt -m 1024 -cpu cortex-a53 \
  -kernel installer-linux \
  -initrd installer-initrd.gz \
  -drive if=none,file=hda.qcow2,format=qcow2,id=hd \
  -device virtio-blk-pci,drive=hd \
  -netdev user,id=mynet \
  -device virtio-net-pci,netdev=mynet \
  -nographic -no-reboot
  ```

## Extracting kernel: 
para ver o conteudo do /boot/ no ubuntu:


```
sudo chmod 644 /boot/vmlinuz* 
```
(não consegui usar o comando do site então copiei toda partição de boot)

~~virt-copy-out -a hda.qcow2 /boot/vmlinuz-4.9.0-12-arm64 /boot/initrd.img-4.9.0-12-arm64 .~~
```
virt-copy-out -a hda.qcow2 /boot/ 
```

### boot:
```
~/qemu/qemu-4.2.0/aarch64-softmmu/qemu-system-aarch64 -M virt -m 1024 -cpu cortex-a53 \
  -kernel vmlinuz-4.9.0-12-arm64 \
  -initrd initrd.img-4.9.0-12-arm64 \
  -append 'root=/dev/vda2' \
  -drive if=none,file=hda.qcow2,format=qcow2,id=hd \
  -device virtio-blk-pci,drive=hd \
  -netdev user,id=mynet \
  -device virtio-net-pci,netdev=mynet \
  -nographic
  ```
