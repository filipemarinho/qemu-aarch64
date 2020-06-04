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
