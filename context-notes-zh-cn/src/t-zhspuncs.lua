zhspuncs = zhspuncs or {}

local glyph = nodes.pool.register (node.new ("glyph", 0))

local glyph_flag   = node.id ('glyph')
local glue_flag    = node.id ('glue')
local hlist_flag   = node.id ('hlist')
local kern_flag    = node.id ('kern')
local penalty_flag = node.id ('penalty')
local math_flag    = node.id ('math')

local fonthashes = fonts.hashes
local fontdata   = fonthashes.identifiers
local quaddata   = fonthashes.quads

local node_count = node.count
local node_dimensions = node.dimensions
local node_traverse_id = node.traverse_id
local node_slide = node.slide
local list_tail = node.tail
local insert_before = node.insert_before
local insert_after = node.insert_after
local new_glue = nodes.pool.glue
local new_kern = nodes.pool.kern
local new_glue_spec = nodes.pool.glue_spec
local new_penalty = nodes.pool.penalty
local new_rule    = nodes.pool.rule

local tasks = nodes.tasks


local puncs = {
    [0x2018] = {0.5, 0.1, 1.0, 1.0}, -- ‘
    [0x201C] = {0.5, 0.1, 0.5, 1.0}, -- “
    [0x3008] = {0.5, 0.1, 1.0, 1.0}, -- 〈
    [0x300A] = {0.5, 0.1, 1.0, 1.0}, -- 《
    [0x300C] = {0.5, 0.1, 1.0, 1.0}, -- 「
    [0x300E] = {0.5, 0.1, 1.0, 1.0}, -- 『
    [0x3010] = {0.5, 0.1, 1.0, 1.0}, -- 【
    [0x3014] = {0.5, 0.1, 1.0, 1.0}, -- 〔
    [0x3016] = {0.5, 0.1, 1.0, 1.0}, -- 〖
    [0xFF08] = {0.5, 0.1, 1.0, 1.0}, -- （
    [0xFF3B] = {0.5, 0.1, 1.0, 1.0}, -- ［
    [0xFF5B] = {0.5, 0.1, 1.0, 1.0}, -- ｛
    [0x2019] = {0.1, 0.5, 1.0, 0.0}, -- ’
    [0x201D] = {0.1, 0.5, 1.0, 0.0}, -- ”
    [0x3009] = {0.1, 0.5, 1.0, 0.5}, -- 〉
    [0x300B] = {0.1, 0.5, 1.0, 0.5}, -- 》
    [0x300D] = {0.1, 0.5, 1.0, 0.5}, -- 」
    [0x300F] = {0.1, 0.5, 1.0, 0.5}, -- 』
    [0x3011] = {0.1, 0.5, 1.0, 0.5}, -- 】
    [0x3015] = {0.1, 0.5, 1.0, 0.5}, -- 〕
    [0x3017] = {0.1, 0.5, 1.0, 0.5}, -- 〗
    [0xFF09] = {0.1, 0.5, 1.0, 0.5}, -- ）
    [0xFF3D] = {0.1, 0.5, 1.0, 0.5}, -- ］
    [0xFF5D] = {0.1, 0.5, 1.0, 0.5}, -- ｝
    -- 需要特殊处理
    [0x2014] = {0.0, 0.0, 1.0, 1.0}, -- —
    [0x2026] = {0.1, 0.1, 1.0, 1.0},    -- …
    [0x2500] = {0.0, 0.0, 1.0, 1.0},    -- ─
    [0x3001] = {0.15, 0.5, 1.0, 0.5},   -- 、
    [0x3002] = {0.15, 0.6, 1.0, 0.3},   -- 。
    [0xFF01] = {0.15, 0.5, 1.0, 0.5},   -- ！
    [0xFF05] = {0.0, 0.0, 1.0, 0.5},    -- ％
    [0xFF0C] = {0.15, 0.5, 1.0, 0.3},   -- ，
    [0xFF0E] = {0.15, 0.5, 1.0, 0.5},   -- ．
    [0xFF1A] = {0.15, 0.5, 1.0, -0.1},   -- ：
    [0xFF1B] = {0.15, 0.5, 1.0, 0.5},   -- ；
    [0xFF1F] = {0.15, 0.5, 1.0, 0.5},   -- ？
}

local function is_zhcnpunc_node (n)
    local n_is_punc = 0
    if puncs[n.char] then
	return true
    end  
    return false
end

local function is_zhcnpunc_node_group (n)
    local n_is_punc = 0
    if puncs[n.char] then
	n_is_punc = 1
    end
    local nn = n.next
    local nn_is_punc = 0
    -- 还需要穿越那些非 glyph 结点
    while nn_is_punc == 0 and nn and n_is_punc == 1 do
	if nn.id == glyph_flag then
	    if puncs[nn.char] then nn_is_punc = 1 end
	    break
	end
	nn = nn.next
    end
    return n_is_punc + nn_is_punc
end

local function is_cjk_ideo (n)
    -- CJK Ext A
    if n.char >= 13312 and n.char <= 19893 then
	return true
	-- CJK
    elseif n.char >= 19968 and n.char <= 40891 then
	return true
	-- CJK Ext B
    elseif n.char >= 131072 and n.char <= 173782 then
	return true
    else
	return false
    end
end

local function quad_multiple (font, r)
    local quad = quaddata[font]
    return r * quad
end

local function process_punc (head, n, punc_flag, punc_table)
    local desc = fontdata[n.font].descriptions[n.char]
    if not desc then return end
    local quad = quad_multiple (n.font, 1)

    -- 像 $\ldots$ 这样的符号竟然没有边界盒，只好忽略并返回
    -- if desc.boundingbox == nil then return end

    local l_space = desc.boundingbox[1] / desc.width
    local r_space = (desc.width - desc.boundingbox[3]) / desc.width
    local l_kern, r_kern = 0.0, 0.0

    if punc_flag == 1 then
	l_kern = (punc_table[n.char][1] - l_space) * quad
	r_kern = (punc_table[n.char][2] - r_space) * quad
    elseif punc_flag == 2 then
	l_kern = (punc_table[n.char][1] * punc_table[n.char][3] - l_space) * quad
	r_kern = (punc_table[n.char][2] * punc_table[n.char][4] - r_space) * quad
    end

    insert_before (head, n, new_kern (l_kern))
    insert_after (head, n, new_kern (r_kern))
end

local function compress_punc (head)
    for n in node_traverse_id (glyph_flag, head) do
	local n_flag = is_zhcnpunc_node_group (n)
	if n_flag ~= 0 then
	    process_punc (head, n, n_flag, puncs)
	end
    end
end

function zhspuncs.my_linebreak_filter (head, is_display)
    compress_punc (head)
    return head, true
end

function zhspuncs.opt ()
    tasks.appendaction("processors","after","zhspuncs.my_linebreak_filter")
end

fonts.protrusions.vectors['myvector'] = {  
   [0xFF0c] = { 0, 0.60 },  -- ，
   [0x3002] = { 0, 0.60 },  -- 。
   [0x2018] = { 0.60, 0 },  -- ‘
   [0x2019] = { 0, 0.60 },  -- ’
   [0x201C] = { 0.60, 0 },  -- “
   [0x201D] = { 0, 0.60 },  -- ”
   [0xFF1F] = { 0, 0.60 },  -- ？
   [0x300A] = { 0.60, 0 },  -- 《
   [0x300B] = { 0, 0.60 },  -- 》
   [0xFF08] = { 0.50, 0 },  -- （
   [0xFF09] = { 0, 0.50 },  -- ）
   [0x3001] = { 0, 0.50 },  -- 、
   [0xFF0E] = { 0, 0.50 },  -- ．
}
fonts.protrusions.classes['myvector'] = {
   vector = 'myvector', factor = 1
}

