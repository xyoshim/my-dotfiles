#! /bin/sh

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 gcc_ver_major gcc_ver_extend ver_binutils"
    exit 1
fi

GVER_MAJOR="$1"
GVER_EXT="$2"
BVER="$3"
GVER="${GVER_MAJOR}${GVER_EXT}"

arch_build="`/usr/bin/uname -s`" || arch_build="unknown"
processor_build="`/usr/bin/uname -p`" || /bin/true
hostname_short="`/usr/bin/hostname -s`" || hostname_short="unknown"
triplet_base="${triplet_base:=""}"

gcc_src_rel="../gcc-${GVER}"
binutils_src_rel="../binutils-${BVER}"
prefix_abs_base="${base_prefix:="/usr/local/gcc"}"
prefix_abs_dir="${prefix_abs_dir:="${prefix_abs_base}/${GVER}"}"
build_abs_base="${build_abs_base:="/usr/opt/src/gcc-releases"}"
build_abs_dir="${build_abs_base}/build-${GVER_MAJOR}"
bindir_suffix="${bindir_suffix:=""}"
libdir_suffix="${libdir_suffix:=""}"
prefix_abs_flags="${prefix_abs_flags:="--prefix=${prefix_abs_dir}"}"
libdir_abs_flags="${libdir_abs_flags:="--libdir=${prefix_abs_dir}/lib${libdir_suffix}"}"
case $arch_build in
  *Linux)
    if [ "$processor_build" == "x86_64" ]; then
      triplet_base="${triplet_base:="x86_64-pc-linux"}"
      libdir_suffix="${libdir_suffix:="64"}"
    fi
    case "$hostname_short" in
      co-pilot)
        build_abs_base="/usr/opt/src/gcc-releases"
        SUPPORT_DIR="${SUPPORT_DIR:="/usr/local/adv"}"
        stdcxx_abi_flags="${stdcxx_abi_flags:="--with-default-libstdcxx-abi=gcc4-compatible"}"
        ;;
      centos8)
        build_abs_base="/usr/opt/src/gcc-releases"
        SUPPORT_DIR="${SUPPORT_DIR:="/usr/local"}"
        ;;
      alma9)
        build_abs_base="/usr/opt/src/gcc-releases"
        SUPPORT_DIR="${SUPPORT_DIR:="/usr/local"}"
        ;;
      *)
        ;;
    esac
    ;;
  *)
    ;;
esac
triplet_base="${triplet_base:="$($build_abs_dir/$gcc_src_rel/config.guess)"}" || triplet_base="unknown"
if [ "$triplet_base" != "unknown" ]; then
    triplet_host="${triplet_host:="--host=${triplet_base}"}"
    triplet_build="${triplet_build:="--build=${triplet_base}"}"
    triplet_target="${triplet_target:="--target=${triplet_base}"}"
else
    triplet_host="${triplet_host:=""}"
    triplet_build="${triplet_build:=""}"
    triplet_target="${triplet_target:=""}"
fi
stdcxx_abi_flags="${stdcxx_abi_flags:=""}"
SUPPORT_DIR="${SUPPORT_DIR:=""}"
if [ "${SUPPORT_DIR}" == "" ]; then
    SUPPORT_BIN=""
    SUPPORT_INC=""
    SUPPORT_LIB=""
else
    SUPPORT_BIN="${SUPPORT_DIR}/bin${bindir_suffix}"
    SUPPORT_INC="${SUPPORT_DIR}/include"
    SUPPORT_LIB="${SUPPORT_DIR}/lib${libdir_suffix}"
    zlib_flags="--with-system-zlib"
fi

case "$hostname_short" in
  co-pilot)
    libelf_flags="${libelf_flags:="--with-libelf-include=/usr/include --with-libelf-lib=/usr/lib${libdir_suffix}"}"
    gmp_flags="${gmp_flags:="--with-gmp-include=${SUPPORT_INC} --with-gmp-lib=${SUPPORT_LIB}"}"
    mpfr_flags="${mpfr_flags:="--with-mpfr-include=${SUPPORT_INC} --with-mpfr-lib=${SUPPORT_LIB}"}"
    mpc_flags="${mpc_flags:="--with-mpc-include=${SUPPORT_INC} --with-mpc-lib=${SUPPORT_LIB}"}"
    isl_flags="${isl_flags:="--with-isl-include=${SUPPORT_INC} --with-isl-lib=${SUPPORT_LIB}"}"
    zlib_flags="--with-system-zlib"
#    zlib_flags="--with-system-zlib --with-zstd-include=/usr/include --with-zstd-lib=/usr/lib64"
    ;;
  alma9)
    isl_flags="${isl_flags:="--with-isl-include=${SUPPORT_INC} --with-isl-lib=${SUPPORT_LIB}"}"
#    zlib_flags="--with-system-zlib"
    ;;
  *)
    ;;
esac
libelf_flags="${libelf_flags:=""}"
gmp_flags="${gmp_flags:=""}"
mpfr_flags="${mpfr_flags:=""}"
mpc_flags="${mpc_flags:=""}"
isl_flags="${isl_flags:=""}"
zlib_flags="${zlib_flags:=""}"

shared_static_flags="${shared_static_flags:="--enable-shared --enable-static"}"
thread_flags="${thread_flags:="--enable-threads=posix --enable-tls"}"
misc_flags="${misc_flags:=""}"
atexit_flags="${atexit_flags:="--enable-__cxa_atexit"}"
plugin_flags="${plugin_flags:="--enable-plugin"}"
binutils_gold_flags="${binutils_gold_flags:="--enable-gold"}"
build_langs="${build_langs:="--enable-languages=c,c++,objc,obj-c++,fortran,lto"}"
bootstrap_flags="${bootstrap_flags:="--enable-bootstrap"}"
multilib_flags="${multilib_flags:="--enable-multilib"}"

case "$hostname_short" in
#      multilib_flags="${multilib_flags} --with-arch-64=x86-64-v2 --with-arch-32=i686"
#      misc_flags="${misc_flags} --with-build-config=bootstrap-lto --disable-libunwind-exceptions --enable-linker-build-id --with-gcc-major-version-only"
#      misc_flags="${misc_flags} --with-build-config=bootstrap-lto --without-system-libunwind --enable-linker-build-id --with-gcc-major-version-only"
  alma9)
    if test "${GVER_MAJOR}" -ge "11" ; then
      multilib_flags="${multilib_flags} --with-arch-64=x86-64-v2"
      misc_flags="${misc_flags} --without-system-libunwind --enable-linker-build-id --with-gcc-major-version-only"
    fi
    ;;
  *)
    ;;
esac

common_configure_flags="${prefix_abs_flags} ${triplet_host} ${triplet_build} ${triplet_target} ${build_langs} ${libelf_flags} ${gmp_flags} ${mpfr_flags} ${mpc_flags} ${isl_flags} ${shared_static_flags} ${thread_flags} ${atexit_flags} ${plugin_flags} ${bootstrap_flags} ${multilib_flags} ${stdcxx_abi_flags} ${binutils_gold_flags} ${misc_flags}"

new_prefix="${prefix_abs_dir}"
old_prefix="${prefix_abs_base}/${GVER_MAJOR}"

PATH="${new_prefix}/bin${bindir_suffix}:${new_prefix}/bin:${old_prefix}/bin${bindir_suffix}:${old_prefix}/bin:${SUPPORT_BIN}:$PATH"; export PATH
if [ "${LD_RUN_PATH}" == "" ]; then
    olg_ld_run_path=""
else
    olg_ld_run_path=":${LD_RUN_PATH}"
fi
LD_RUN_PATH="${new_prefix}/lib${libdir_suffix}:${new_prefix}/lib:${old_prefix}/lib${libdir_suffix}:${old_prefix}/lib"
LDFLAGS="-Wl,-rpath,${new_prefix}/lib${libdir_suffix} -Wl,-rpath,${new_prefix}/lib -Wl,-rpath,${old_prefix}/lib${libdir_suffix} -Wl,-rpath,${old_prefix}/lib"
if [ "${SUPPORT_LIB}" == "" ]; then
    LD_RUN_PATH="${LD_RUN_PATH}${olg_ld_run_path}"
    PKG_CONFIG_PATH="${PKG_CONFIG_PATH=""}"
else
#    LD_RUN_PATH="${LD_RUN_PATH}:${SUPPORT_LIB}${olg_ld_run_path}"
    LD_RUN_PATH="${LD_RUN_PATH}:${SUPPORT_LIB}${olg_ld_run_path}"
    LDFLAGS="${LDFLAGS} -Wl,-rpath,${SUPPORT_LIB}"
    PKG_CONFIG_PATH="${SUPPORT_LIB}/pkgconfig:${PKG_CONFIG_PATH=""}"
fi
export LD_RUN_PATH
export LDFLAGS
export PKG_CONFIG_PATH
CC="${CC:="gcc"}"; export CC
CFLAGS="${CFLAGS:="-pipe -O2"}"; export CFLAGS
CXX="${CXX:="g++"}"; export CXX
CXXFLAGS="${CXXFLAGS:="$CFLAGS"}"; export CXXFLAGS
FC="${FC:="gfortran"}"; export FC
FFLAGS="${FFLAGS:="$CFLAGS"}"; export FFLAGS
FCFLAGS="${FCFLAGS:="$CFLAGS"}"; export FCFLAGS

echo "new_prefix : $new_prefix"
echo "old_prefix : $old_prefix"
echo "GVER : $GVER"
echo "BVER : $BVER"
echo "triplet_base = $triplet_base"
echo "triplet_host = $triplet_host"
echo "triplet_build = $triplet_build"
echo "triplet_target = $triplet_target"
echo "prefix_abs_dir : $prefix_abs_dir"
echo "build_abs_dir : $build_abs_dir"
echo "gcc_src_rel : $gcc_src_rel"
echo "binutils_src_rel : $binutils_src_rel"
echo "common_configure_flags : $common_configure_flags"
echo "PATH : $PATH"
echo "LD_RUN_PATH : $LD_RUN_PATH"
echo "LDFLAGS : $LDFLAGS"
echo "PKG_CONFIG_PATH : $PKG_CONFIG_PATH"

if [ -d "${build_abs_dir}" ]; then
    cd "${build_abs_dir}"
else
    echo "Not found ${build_abs_dir} ." ; exit 1
fi

if [ -f "${prefix_abs_dir}/gcc_complete" ]; then
    echo "gcc $GVER already built."
    exit 0
fi

if [ -f "${prefix_abs_dir}/binutils_complete" ]; then
    echo "Skip binutils build"
else
    if [ -f "${prefix_abs_dir}/binutils_configured" ]; then
        echo "Skip binutils configure."
    else
        rm -rf ./*
        binutils_configure_flags="${prefix_abs_flags} ${triplet_host} ${triplet_build} ${triplet_target} ${libelf_flags} ${gmp_flags} ${mpfr_flags} ${mpc_flags} ${isl_flags} ${shared_static_flags} ${thread_flags} ${plugin_flags} ${zlib_flags} ${binutils_gold_flags} ${misc_flags}"
        time $binutils_src_rel/configure $binutils_configure_flags
        retval=$?
        if [ $retval -eq 0 ]; then
            if [ ! -d "${prefix_abs_dir}" ]; then
                mkdir -p "${prefix_abs_dir}"
            fi
            touch "${prefix_abs_dir}/binutils_configured"
        else
            exit $retval
        fi
    fi
    time make all install
    retval=$?
    if [ $retval -eq 0 ]; then
        touch "${prefix_abs_dir}/binutils_complete"
        rm -f "${prefix_abs_dir}/binutils_configured"
    else
        exit $retval
    fi
fi

if [ -f "${prefix_abs_dir}/gcc_complete" ]; then
    echo "Skip gcc build"
else
    if [ -f "${prefix_abs_dir}/gcc_configured" ]; then
        echo "Skip gcc configure."
    else
        rm -rf ./*
        gcc_configure_flags="${prefix_abs_flags} ${triplet_host} ${triplet_build} ${triplet_target} ${build_langs} ${libelf_flags} ${gmp_flags} ${mpfr_flags} ${mpc_flags} ${isl_flags} ${shared_static_flags} ${thread_flags} ${atexit_flags} ${plugin_flags} ${zlib_flags} ${bootstrap_flags} ${multilib_flags} ${stdcxx_abi_flags} ${misc_flags}"
        time $gcc_src_rel/configure $gcc_configure_flags
        retval=$?
        if [ $retval -eq 0 ]; then
            touch  "${prefix_abs_dir}/gcc_configured"
        else
            exit $retval
        fi
    fi
    time make bootstrap-lean install
    retval=$?
    if [ $retval -eq 0 ]; then
        if [ ! -f "${prefix_abs_dir}/bin/cc" -a -x "${prefix_abs_dir}/bin/gcc" ];then
            ( cd "${prefix_abs_dir}/bin" && ln -s gcc cc )
        fi
        if [ -L "$old_prefix" ]; then
            rm -f "$old_prefix"
        fi
        if [ ! -d "$old_prefix" ]; then
            ( cd "${prefix_abs_dir}/.." && ln -s "$(basename "${prefix_abs_dir}")" "$(basename "${old_prefix}")" )
        fi
        touch  "${prefix_abs_dir}/gcc_complete"
        rm -f "${prefix_abs_dir}/binutils_complete"
        rm -f "${prefix_abs_dir}/gcc_configured"
        rm -rf ./*
    else
        exit $retval
    fi
fi

exit 0
