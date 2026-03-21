-- Plugins: mini.surround
-- https://github.com/nvim-mini/mini.surround#features
--
--   sa  增加环绕：Normal 里先 sa 再选动作（如 iw / aw）；Visual 里先选中再 sa example: word -> saiw' -> 'word'
--   sd  删除环绕：sd 后输入标识字符  example: 'word' -> sd' -> word
--   sr  替换环绕：sr <旧标识> <新标识>  example: "word" -> sr'" -> "word"
--   sf  找到右侧的环绕并跳到其上；sF 向左找
--   sh  高亮当前环绕（持续时间在 setup 的 highlight_duration） example: (aa) (bb) (cc)
--   后缀 l / n：与 delete/replace/find/highlight 联用，表示按「上一个 / 下一个」搜索方式找环绕
--     （具体见 :h MiniSurround.config 里 search_method、suffix_last、suffix_next）
--
-- 「标识」单字符（输入/输出含义不同，详见官方 README）：
--   f   函数调用：(input) 匹配调用；(output) 提示输入函数名
--   t   HTML/XML 标签：(input) 匹配同名标签；(output) 提示标签名
--   ( ) [ ] { } < >  成对括号；其它可输入字符可作相同左右符号的环绕
--   ?   交互：分别输入左、右边界
--
-- 其它：文本修改可 dot-repeat；支持 [count]；搜索范围等与 n_lines、search_method 相关。
-- 必须 require('mini.surround').setup() 才会启用（下面已调用默认 setup）。

return {
  {
    "nvim-mini/mini.surround",
    version = false,
    config = function()
      require("mini.surround").setup()
    end,
  },
}
