-- join all planes into one
local function join_planes(row_data, ox)
  if (row_data == nil) return nil

  local plane = {}
  for i = 1, 3 do
    for j = 1, #row_data[i] do
      local token = row_data[i][j]
      add(plane, {x1 = token.x1 + ox, x2 = token.x2 + ox, p = token.p})
    end
  end

  for i = 2, #plane do
    local j = i
    while j > 1 and plane[j-1].x1 > plane[j].x1 do
      plane[j], plane[j-1] = plane[j-1], plane[j]
      j = j - 1
    end
  end

  return plane
end

-- split into multiple planes (again)
local function split_planes(row)
  local row_data = {{}, {}, {}}

  for token in all(row) do
    if token.p < 16 then
      add(row_data[1], token)
    elseif token.p <= 0xff then
      add(row_data[2], token)
    else
      add(row_data[3], token)
    end
  end

  return row_data
end

-- overlap one image over another
Pen.composite = function (fg_img_or_name, bg_img_or_name, ...)
  local fg = Pen.get(fg_img_or_name)
  local bg = Pen.get(bg_img_or_name)
  local args = {...}
  local ox, oy = args[1] or 0, args[2] or 0 -- foreground offsets

  local matrix = {}
  for y = min(oy, 1), max(oy + fg.h, bg.h) do
    local fg_plane = join_planes(fg.matrix[y - oy], max(ox, 0))
    local bg_plane = join_planes(bg.matrix[y], max(-ox, 0))

    if fg_plane == nil then
      add(matrix, split_planes(bg_plane))
    elseif bg_plane == nil then
      add(matrix, split_planes(fg_plane))
    else
      local composite_plane = {}
      local bg_i = 1
      local bg_token = bg_plane[bg_i]

      for fg_token in all(fg_plane) do
        while bg_token != nil and bg_token.x2 <= fg_token.x2 do
          if bg_token.x1 < fg_token.x1 then
            add(composite_plane, {
              x1 = bg_token.x1,
              x2 = min(bg_token.x2, fg_token.x1 - 1),
              p = bg_token.p})
          end
          bg_i += 1
          bg_token = bg_plane[bg_i]
        end

        add(composite_plane, fg_token)

        if bg_token != nil then
          if bg_token.x1 < fg_token.x1 then
            add(composite_plane, {x1 = bg_token.x1, x2 = fg_token.x1 - 1, p = bg_token.p})
          end
          bg_token.x1 = max(bg_token.x1, fg_token.x2 + 1)
        end
      end

      while bg_token != nil do
        add(composite_plane, bg_token)
        bg_i += 1
        bg_token = bg_plane[bg_i]
      end

      add(matrix, split_planes(composite_plane))
    end
  end

  return {
    name = fg.name .. ' + ' .. bg.name,
    w = max(fg.w, bg.w),
    h = #matrix,
    dpal = bg.dpal,
    vcol = bg.vcol,
    matrix = matrix,
  }
end
