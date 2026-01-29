with import <nixpkgs> { };
{
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
      inherit pkgs;
    };
  };
  allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "fcitx5-flypy"
      "ventoy-qt5"
      "libnvshmem"
      "libcufile"
      "libcusparse_lt"
      "torch"
      "triton"
      "cudnn"
      "nvidia-x11"
      "libnpp"
      "libcusparse"
      "libnvjitlink"
      "libcusolver"
      "libcurand"
      "libcufft"
      "libcublas"
      "cuda_sanitizer_api"
      "cuda_profiler_api"
      "cuda_nvtx"
      "cuda_nvrtc"
      "cuda_nvml_dev"
      "cuda_cuxxfilt"
      "cuda_cupti"
      "cuda_cudart"
      "cuda_cccl"
      "cuda_nvprune"
      "cuda_nvdisasm"
      "cuda_nvcc"
      "cuda_gdb"
      "cuda_cuobjdump"
      "cuda-merged"
      "qq"
      "wechat"
      "rime-flypy"
    ];
}
