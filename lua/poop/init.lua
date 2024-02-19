local Plugin = {}

Plugin.__index = Plugin

function Plugin:new(config)
  local instance = setmetatable({
    init_config = {
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 0,
      height = 1,
      width = 2,
    },
    settings = {
      speed = 80.0,
      angle = 20.0,
      frames = 120,
      delay = 0.002,
      emoji = '💩',
    },
  }, self)

  if config and config.init_config then
    for k, v in pairs(config.init_config) do
      instance.init_config[k] = v
    end
  end

  if config and config.settings then
    for k, v in pairs(config.settings) do
      instance.settings[k] = v
    end
  end

  -- Calculate velocities here if they depend on settings
  instance.settings.x_velocity = instance.settings.speed * math.cos(math.rad(instance.settings.angle))
  instance.settings.y_velocity = instance.settings.speed * math.sin(math.rad(instance.settings.angle))

  return instance
end

function Plugin:animate(window, direction)
  for time_elapsed = 1, self.settings.frames do
    vim.defer_fn(function()
      local step = time_elapsed * 0.1
      local current_x = direction * (self.settings.x_velocity * step)
      local current_y = 0 - self.settings.y_velocity * step + (0.5 * 9.8 * (step ^ 2))

      -- Update the window position
      local config = vim.tbl_deep_extend('force', self.init_config, {
        relative = 'cursor',
        row = current_y / 100,
        col = current_x / 100,
      })
      vim.api.nvim_win_set_config(window, config)
    end, self.settings.delay * 1000 * time_elapsed)
  end

  -- Close the window after the last frame
  vim.defer_fn(function()
    vim.api.nvim_win_close(window, true)
  end, self.settings.frames * self.settings.delay * 1000)
end

function Plugin:eject(left, right)
  local directions = { [-1] = left or self.settings.emoji, [1] = right or self.settings.emoji }
  for direction, emoji in pairs(directions) do
    -- Create a new buffer
    local buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buffer, 0, -1, true, { emoji })
    -- Create a floating window
    local window = vim.api.nvim_open_win(buffer, false, self.init_config)
    vim.api.nvim_win_set_option(window, 'winhl', 'Normal:Poop')

    self:animate(window, direction)
  end
end

local function setup(config)
  local instance = Plugin:new(config)
  return {
    eject = function(left, right)
      instance:eject(left, right)
    end,
  }
end

return {
  setup = setup,
}
