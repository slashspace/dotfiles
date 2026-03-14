# ============================================================================
# Zsh History Configuration Module(中文：ZSH 命令历史记录配置模块)
# ============================================================================

# Path to the history file(中文：历史记录文件的存储路径)
HISTFILE=~/.zsh_history
# Number of history entries to keep in memory(中文：在内存中保存的历史记录条目数量)
HISTSIZE=10000
# Maximum number of commands to save to the history file(中文：保存到历史记录文件中的命令数量上限)
SAVEHIST=20000

# Check if the history file exists, if not, create it(中文：检查历史记录文件是否存在，如果不存在，则创建它)
if [[ ! -f $HISTFILE ]]; then
  touch $HISTFILE
  chmod 600 $HISTFILE
fi


# Append commands to the history file as they are entered(中文：将命令追加到历史记录文件中, 而不是覆盖)
setopt appendhistory
# Record timestamp of each command (helpful for auditing)(中文：记录每条命令的时间戳，便于审计和查找)
setopt extendedhistory
# Share command history data between all sessions(中文：在所有 zsh 会话之间共享命令历史数据)
setopt sharehistory
# Incrementally append to the history file, rather than waiting until the shell exits(中文：实时增量追加到历史记录文件，而不是等到 zsh 退出时再写入)
setopt incappendhistory
# Ignore duplicate commands in a row(中文：忽略连续重复的命令，避免历史记录被重复命令填满)
setopt histignoredups
# Exclude commands that start with a space(中文：忽略以空格开头的命令，可用于隐藏敏感命令(如密码))
setopt histignorespace
