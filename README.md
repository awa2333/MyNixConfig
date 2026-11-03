<div align="center">

# MyNixConfig

**NixOS × Home Manager · Hyprland × Stylix**

一份面向日常使用的声明式 Linux 桌面配置：系统、应用与主题一起版本化。

[![NixOS](https://img.shields.io/badge/NixOS-Flakes-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![Home Manager](https://img.shields.io/badge/Home_Manager-integrated-5277C3)](https://nix-community.github.io/home-manager/)
[![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-00A4D6)](https://hypr.land/)
[![Secrets](https://img.shields.io/badge/Secrets-sops--nix-4A8B45)](https://github.com/Mic92/sops-nix)

</div>

> **这是 Luke 的个人主机配置，不是可直接套用的通用安装镜像。** 首次使用前必须调整磁盘 UUID、显卡 PCI 地址、用户名、显示器和 SOPS recipient。不要直接在其他机器上执行 `switch`。

## 导航

- [配置与架构](#配置与架构)
- [硬件与桌面](#硬件与桌面)
- [首次安装](#首次安装)
- [密钥与凭据管理](#密钥与凭据管理)
- [灾难恢复](#灾难恢复)
- [日常运维](#日常运维)
- [验证范围与排障](#验证范围与排障)

## 配置与架构

系统由 **Flake 驱动**，`flake.lock` 固定依赖版本；Home Manager 集成在 NixOS 模块中，与系统共享包集和 overlay。一次系统重建同步管理用户环境，无需另跑一套独立 HM 部署。

```text
flake.nix / flake.lock
└── nixosConfigurations.nixos               # Flake 输出名；用户名是 luke
    ├── configuration.nix                  # 启动、用户、网络、服务、SOPS、Stylix
    ├── hardware-configuration.nix         # 本机磁盘、文件系统与硬件探测结果
    ├── misc.nix                           # 资源包 overlay
    └── homemanagerModule/
        ├── default.nix                    # 用户应用、Git、终端与共享设置
        ├── hyprwm/                        # Hyprland Lua、Noctalia、视频壁纸
        ├── zshShell/                      # Zsh、Starship、按需凭据包装函数
        ├── nvim/                          # 默认 Neovim/NvChad；可选 Nixvim 后端
        ├── fcitx5/                        # 中文输入法与 Rime
        └── firefox/                       # 浏览器策略与配置
```

- **桌面**：Hyprland + Noctalia + mpvpaper，SDDM 登录，PipeWire 音频。
- **主题**：Stylix 使用 Tokyo Night Storm；Hyprland 边框颜色只由 Stylix 管理，避免重复键覆盖。Kitty、Fcitx5、Neovim 保留有意的局部主题例外。
- **编辑器**：默认 Neovim + NvChad，Conform 使用 Biome 格式化 JSON/JSONC，YAML 单独使用 yamlfmt。
- **资源**：部分背景/主题来自个人 GitCode 资源仓库和 `nur.repos.awa2333`，首次构建需要相应网络访问。

**纯求值边界**：系统配置可以直接求值；当前顶层开发 shell 使用 devenv，依赖工作目录发现，不能声称所有 Flake outputs 都能通过严格纯求值的 `flake check`。详见末尾说明。

## 硬件与桌面

以下是当前配置确认的参数，不推测具体笔记本营销型号或独显型号：

| 项目 | 当前设置 |
| --- | --- |
| 平台 | ASUS 笔记本平台，启用 `asusd`；`x86_64-linux` |
| 图形 | AMD 集显 + NVIDIA 独显，PRIME offload；NVIDIA open 驱动 |
| 内屏 | `eDP-1`，1920 × 1080 @ 144 Hz，缩放 4/3 |
| 外屏 | `HDMI-A-1`，2560 × 1440 @ 144 Hz，缩放 4/3 |
| 布局 | 外屏在左、内屏在右；外屏逻辑宽度 1920，内屏位置 `1920x0` |
| 工作区 | 1、2 绑定外屏；3 绑定内屏 |
| 启动/磁盘 | UEFI + GRUB；根分区 ext4，EFI 挂载于 `/efi`，独立 swap |
| 版本基线 | NixOS 与 HM `stateVersion = "26.05"`；不是应随升级修改的版本号 |

`homemanagerModule/hyprwm/default.nix` 顶部的 `internalMonitor = "eDP-1"` 同时用于显示器、工作区和视频壁纸。若机型使用 `eDP-2`，**只改这个变量**，不要复制第二条 workspace 3 规则。外屏型号、刷新率或接口变化时，另行调整 `HDMI-A-1` 规则；当前不是任意显示器自动发现方案。

用 `hyprctl monitors` 检查接口，用 `lspci` 核对并修改 `configuration.nix` 中的 PRIME PCI 地址。需要独显的应用可用 `nvidia-offload <command>`；GPU、输入法和热插拔效果仍需在真实会话测试。

## 首次安装

### 1. 先准备恢复能力，再安装

准备 NixOS 安装介质、可用的直连 DNS/网络，以及一份**离线备份的 age 私钥**。现有密文只能由匹配 `.sops.yaml` recipient 的私钥解密，Home Manager 不会创建或恢复这把钥匙。

> 根分区当前没有在本仓库中声明 LUKS。SOPS 保护 Git 中的密文，不保护与私钥同盘、未加密磁盘的离线读取。若要启用全盘加密，先备份并设计分区/引导与恢复流程，不要照抄破坏性分区命令。

### 2. 挂载与适配配置

先按自己的磁盘方案挂载根分区到 `/mnt`、EFI 到 `/mnt/efi`；若 `/home` 独立挂载或加密，必须先挂载/解锁它。以下命令在安装介质中执行，假设 `/mnt/etc/nixos` 尚不存在：

```bash
sudo git clone https://github.com/awa2333/MyNixConfig /mnt/etc/nixos
sudo nixos-generate-config --root /mnt
cd /mnt/etc/nixos
```

`nixos-generate-config` 会刷新硬件文件；检查实际生成的磁盘 UUID、EFI 路径和 swap。保留本仓库的 `configuration.nix`，逐项适配用户名、显卡、显示器和网络，不要保留他人的密码密文当作自己的登录凭据。

### 3. 在创建用户之前部署 age key

当前配置保留既有路径 **`/home/luke/.config/sops/age/keys.txt`**。在安装目标中预先建立它；此时 `luke` 用户还不存在，所以先用 root 安全部署：

```bash
# /secure-backup/keys.txt 代表已存在、匹配 recipient 的可信备份。
sudo install -d -m 0700 /mnt/home/luke/.config/sops/age
sudo install -o root -g root -m 0600 /secure-backup/keys.txt \
  /mnt/home/luke/.config/sops/age/keys.txt
```

不要把私钥复制进仓库、Nix 路径字面量或 `/nix/store`。安装前分别验证 `secrets.yaml` 和 binary 格式的 Mihomo 文件能解密，输出丢弃而不是打印凭据：

```bash
sudo env SOPS_AGE_KEY_FILE=/mnt/home/luke/.config/sops/age/keys.txt \
  nix shell nixpkgs#sops -c sops --decrypt secrets.yaml >/dev/null
sudo env SOPS_AGE_KEY_FILE=/mnt/home/luke/.config/sops/age/keys.txt \
  nix shell nixpkgs#sops -c sops --input-type binary --output-type binary \
  --decrypt mihomo-secret.yaml >/dev/null
```

**新用户没有原私钥时**：生成自己的 age key（下一节），更换 `.sops.yaml` recipient，并重新加密自己准备的密码 hash、Cookie 和 Mihomo 配置。新生成的 key 不能解密 Luke 的旧密文；不要设置 `generateKey` 后期待旧密文自动恢复。账号密码必须是合法 crypt hash，可用 `mkpasswd -m yescrypt` 交互生成，不能填明文密码。

### 4. 求值、安装与首次启动

```bash
nix eval .#nixosConfigurations.nixos.config.system.build.toplevel.drvPath --show-trace
sudo nixos-install --flake .#nixos

# 预部署 key 时 .config 可能由 root 创建；安装已创建用户后修复父目录所有者。
# 只改 .config，不递归改变私钥目录/文件的 root 所有权。
sudo nixos-enter --root /mnt -c 'chown luke:users /home/luke/.config'
```

root 和 luke 都通过 `hashedPasswordFile` 使用 SOPS 密码，且 `mutableUsers = false`。**解密钥匙与密码 hash 必须在首次激活前就准备好**；不能指望登录后再由 HM 补齐。不要忽视安装器的秘密解密/密码设置错误；在确认可登录前不要移除救援介质。

## 密钥与凭据管理

### 存储与权限

| 文件/路径 | 内容与边界 |
| --- | --- |
| `.sops.yaml` | 公开 age recipient 与加密规则，可以提交 |
| `secrets.yaml` | 加密的 root/luke 密码 hash、网易云 Cookie 等，可以提交 |
| `mihomo-secret.yaml` | **SOPS binary JSON envelope**，不是普通 YAML 密文 |
| `/home/luke/.config/sops/age/keys.txt` | age 私钥；离线备份，0600，不提交、不入 store |
| `/run/secrets/*` | sops-nix 激活时解密的运行时文件；普通 secret 默认 0400 |
| `/run/secrets-for-users/*` | `neededForUsers` 密码，早于用户创建阶段部署 |

Mihomo 使用 systemd `LoadCredential` 读取 root-owned secret，不必设为全局可读或创建静态 mihomo 用户。`mihomoConfig.restartUnits` 已配置为 `[ "mihomo.service" ]`，激活时 secret 变化会要求服务重启。

独立初始化新 key 的示例（**只在新环境使用，不覆盖已有 key**）：

```bash
sudo install -d -m 0700 /home/luke/.config/sops/age
sudo nix shell nixpkgs#age -c age-keygen -o /home/luke/.config/sops/age/keys.txt
sudo chmod 0600 /home/luke/.config/sops/age/keys.txt
sudo nix shell nixpkgs#age -c age-keygen -y /home/luke/.config/sops/age/keys.txt
```

最后一条输出的是**公钥 recipient**。更新 `.sops.yaml` 后，已有密文的 recipient 变更需执行 `sops updatekeys` 并验证新旧恢复 key；只改规则不会重加密旧文件。Mihomo 操作须显式指定 binary 输入/输出类型。编辑 secrets 时使用 `sops`，不要先解密覆盖仓库文件；配置自己的编辑器时也应关闭明文备份/交换文件并使用可信临时目录。

### GitHub API token：降低 Nix rate limit，不进入 store

系统的 `nix.extraOptions` 只包含运行时引用：

```conf
!include /run/secrets/nix-access-tokens
```

`!include` 允许文件缺失，不会因尚未配置 token 而阻止首次安装。**目前不默认声明该 secret**，因为仓库密文中还没有对应 key；必须先准备密文，再启用声明。

1. 创建最小权限、有限有效期的 GitHub token；公开仓库读取不需要授予宽泛写权限。
2. 使用 `sops secrets.yaml` 的安全编辑流程（root-owned key 可用 `sudo env SOPS_AGE_KEY_FILE=/home/luke/.config/sops/age/keys.txt nix shell nixpkgs#sops -c sops secrets.yaml`），在解密视图中增加以下多行字符串，保存后仍为密文：

   ```yaml
   nix-access-tokens: |
     access-tokens = github.com=YOUR_TOKEN
   ```

3. 在 `configuration.nix` 的 `sops.secrets` 中增加：

   ```nix
   nix-access-tokens = {
     # 使用 defaultSopsFile = ./secrets.yaml 中同名 key。
     owner = config.users.users.luke.name;
     mode = "0400";
     restartUnits = [ "nix-daemon.service" ];
   };
   ```

4. 重建系统并确认 `/run/secrets/nix-access-tokens` 权限，不要把内容打印到日志。

此权限允许 Luke 的 Nix 客户端和 root/daemon 读取；仅给 root 访问可能无法解决用户端拉取 Flake 的限流。其他用户不能共享这枚 token；多用户机器宜改用各用户受限文件与各自的 Nix 配置。可选 include 会跳过不可读文件，因此仍遇限流时应检查**执行 Nix 的用户**是否有读权限。

禁止将明文放入 `nix.settings.access-tokens`、`builtins.readFile`、命令行 `--option access-tokens ...` 或全局 `NIX_CONFIG`。不要分享 `nix config show`、环境 dump 或可能包含 token 的调试日志。

### 应用凭据：按需授权，不全局 export

Git/gh 使用 `gh auth login` 与已启用的 credential helper；无需全局 `GITHUB_TOKEN`。交互式 Zsh 提供：

```bash
musicfox                         # 启动该应用时才读取网易云 Cookie
with-github-token some-command   # 仅为该命令及其子进程提供 GITHUB_TOKEN
```

普通 Zsh 脚本、build/devenv 不再从 `.zshenv` 默认获取这些凭据。只有你主动包裹的命令才接收 token，**不要把不可信项目的构建包在授权函数中**。凭据仍可能被同 UID 恶意进程读取，按需环境变量不是秘密保险箱。

更新后在旧 shell 执行 `unset GITHUB_TOKEN MUSICFOX_COOKIE`，并重新登录会话；移除配置不会自动清理已经继承凭据的旧进程。

## 灾难恢复

### 恢复清单

1. 从安装介质启动，解锁并挂载根分区、EFI 和必要的 `/home`。
2. 恢复已知可用的 Git 提交和 `flake.lock`，不要在恢复中顺手更新依赖。
3. 从离线介质恢复**匹配 recipient** 的 age key 到目标 `/mnt/home/luke/.config/sops/age/keys.txt`，权限 0600。
4. 按首次安装步骤分别验证两份密文，再安装/激活并检查 root、luke 登录。
5. 确认 Mihomo、DNS、桌面与数据可用后，再移除介质和清理旧 generations。

如果丢失唯一私钥且没有其他恢复 recipient，SOPS 无法找回秘密：需要重建密码和应用凭据，再重新加密。不应把系统回滚当作密钥备份；secret 轮换和撤销也不一定随系统 generation 回滚。

### 可选：迁移到系统级 key 路径

本次配置不强行改变既有路径，避免本机尚未迁移就无法登录。后续可将 key 与用户 dotfiles 生命周期分离：

```bash
sudo install -d -m 0700 /var/lib/sops-nix
sudo install -o root -g root -m 0600 /home/luke/.config/sops/age/keys.txt \
  /var/lib/sops-nix/key.txt
```

验证备份与新路径解密能力后，再修改 `sops.age.keyFile = "/var/lib/sops-nix/key.txt";` 并重建。确认重启正常、恢复流程已更新后，才处理旧副本。首次安装也要改为预先部署 `/mnt/var/lib/sops-nix/key.txt`。**迁移目录本身不解决未加密磁盘的离线读取风险。**

## 日常运维

以下命令在仓库目录执行；`nh` 已由 HM 安装，显式选择 `nixos` 输出避免依赖机器名猜测。

```bash
# 构建并预览变更，不激活
nh os build . -H nixos

# 同时更新系统与集成的 Home Manager；nh 按需提权
nh os switch . -H nixos --ask
# 或使用标准命令
sudo nixos-rebuild switch --flake .#nixos

# 全量或定向更新 inputs；先检查 lock diff，再求值/构建
nix flake update
nix flake update nixpkgs home-manager

git diff -- flake.lock

# 回滚；如果新系统无法启动，在 GRUB 选择已知可用 generation
sudo nixos-rebuild switch --rollback

# 先预览垃圾回收，再保留最近两周且至少 3 个 generations
nh clean all --dry --keep 3 --keep-since 14d
nh clean all --ask --keep 3 --keep-since 14d

# HM 更新后，当前 Hyprland 会话可显式重新加载配置
hyprctl reload

# 服务与 DNS 诊断（分享日志前检查是否含凭据）
systemctl status mihomo.service
sudo journalctl -u mihomo.service -b
getent hosts github.com
```

不要为了升级修改 `system.stateVersion` 或 `home.stateVersion`；它们记录初始化/兼容基线。清理前先验证新系统可用，避免删除唯一可启动的回滚版本。

## 验证范围与排障

```bash
# 语法：逐个解析所有仓库 Nix 文件
find . -path ./.git -prune -o -name '*.nix' -print0 \
  | xargs -0 -n1 nix-instantiate --parse >/dev/null

# 核心配置：求值所有系统模块，检查 assertions 与属性错误
nix eval .#nixosConfigurations.nixos.config.system.build.toplevel.drvPath --show-trace

# 格式化（会修改文件）；工具最好与项目锁定的 Nixpkgs 保持一致
nix shell nixpkgs#nixfmt -c sh -c \
  'git ls-files -z "*.nix" | xargs -0 nixfmt'
nix shell nixpkgs#statix nixpkgs#deadnix -c sh -c 'statix check .; deadnix .'

# 全输出检查，不构建检查 derivation
nix flake check --no-build --show-trace
```

**已知边界**：当前 `flake check --no-build` 会被 devenv 的“无法确定当前目录” assertion 阻塞。系统 toplevel 求值可独立通过；`.envrc` 使用非纯求值进入开发环境。`--impure` 不是检查必然成功的保证，也不要把这个已知限制误报为系统模块语法错误。完整系统构建、实际安装与 GPU/多屏测试是额外验证，不由成功的 `nix eval` 代替。

- **网络不可用**：系统只使用 `127.0.0.1` DNS，依赖 Mihomo 实际监听本地 DNS。先检查私钥、服务状态和解密后的配置；不要无意加入公网备用 DNS 破坏分流或 fail-closed 策略。
- **密钥轮换后服务未更新**：重建并检查服务重启记录；Mihomo secret 已设置 restartUnits。
- **输入法/显卡问题**：在真实 Wayland 会话分别验证 Qt、GTK、Electron 和 offload，不能仅凭求值判断硬件兼容性。
- **Neovim formatter/LSP 缺失**：部分工具由项目开发环境提供，插件存在不等于所有可执行文件已安装。JSON 必须用 JSON formatter，不能改回 yamlfmt。

### 参考文档

[NixOS Manual](https://nixos.org/manual/nixos/stable/) · [Home Manager Manual](https://nix-community.github.io/home-manager/) · [sops-nix](https://github.com/Mic92/sops-nix) · [Stylix](https://nix-community.github.io/stylix/) · [Hyprland Wiki](https://wiki.hypr.land/) · [devenv Flake integration](https://devenv.sh/guides/using-with-flakes/)
