#!/sbin/sh

ABI=$(getprop ro.product.cpu.abi 2>/dev/null)
case "$ABI" in
	arm64-v8a) ARCH=arm64; LIBDIR=/system/lib64 ;;
	armeabi|armeabi-v7a) ARCH=armhf; LIBDIR=/system/lib ;;
	x86_64) ARCH=amd64; LIBDIR=/system/lib64 ;;
	x86) ARCH=i386; LIBDIR=/system/lib ;;
	*)
		ARCH=${ARCH:-arm64}
		LIBDIR=${LIBDIR:-/system/lib64}
		;;
esac

export ARCH LIBDIR
