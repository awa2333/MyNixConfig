with import <nixpkgs> { };
{
  permittedInsecurePackages = [
    "ventoy-qt5-1.1.07"
  ];
  allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
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
