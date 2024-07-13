function love.load()
  json = require('plugins.json')
  tiny = require('plugins.tiny-ecs')
  class = require('plugins.middleclass')
  bump = require('plugins.bump')
  ldtk = require('plugins.super-simple-ldtk')

  GAME_WIDTH = 200
  GAME_HEIGHT = 200
  GAME_SCALE = 4
  GRAVITY = 25
  MAX_GRAVITY = 800
  JUMP_HEIGHT = 400

  SYSTEMS_IN_ORDER = {
    require('systems.audio-system'),
    require('systems.collision-registration-system'),
    require('systems.keyboard-state-system'),
    require('systems.tile-map-system'),
    require('systems.player-input-system'),
    require('systems.entity-movement-system'),
    require('systems.collision-detection-system'),
    require('systems.camera-system'),
    require('systems.background-sprite-drawing-system'),
    require('systems.sprite-drawing-system'),
    require('systems.foreground-sprite-drawing-system'),
    require('systems.debug-overlay-system'),
    require('systems.entity-cleanup-system'),
    require('systems.time-to-live-system'),
  }

  PALETTE = {
    BACKGROUND = { love.math.colorFromBytes(48, 44, 46) }, --#302c2e
  }

  local windowWidth, windowHeight = love.window.getDesktopDimensions()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  --love.graphics.setBackgroundColor(PALETTE.LIGHTEST)

  logger = require('logger')()

  KeyPressEvent = require('entities.events.key-press')
  KeyReleaseEvent = require('entities.events.key-release')
  ScreenResizeEvent = require('entities.events.screen-resize')

  local joystick_state = require('shared-access.joystick')() --[[@as JoystickState]]
  local keyboard_state = require('shared-access.keyboard')() --[[@as KeyboardState]]
  local entity_factory = require('shared-access.entity-factory')() --[[@as EntityFactory]]

  love.graphics.setLineStyle('rough')
  love.window.setMode(GAME_WIDTH * GAME_SCALE, GAME_HEIGHT * GAME_SCALE)
  bump_world = bump.newWorld(64)
  tiny_world = tiny.world()

  for _, system in ipairs(SYSTEMS_IN_ORDER) do
    if system.initialize then
      system:initialize({
        bump_world = bump_world,
        joystick_state = joystick_state,
        keyboard_state = keyboard_state,
        entity_factory = entity_factory,
      })
    end
    tiny_world:addSystem(system)
  end
  tiny_world:addEntity(entity_factory:build('PLAYER'))
  tiny_world:addEntity(entity_factory:build('PLAYER_TRUCK'))
  tiny_world:addEntity({
    is_event = true,
    load_tile_map = true,
  })
end

function love.update(dt)
  delta_time = dt
end

function love.draw()
  tiny_world:update(delta_time)
end

function love.keypressed(k)
  tiny_world:addEntity(KeyPressEvent(k))
end

function love.keyreleased(k)
  tiny_world:addEntity(KeyReleaseEvent(k))
end

function love.resize(w, h)
  tiny_world:addEntity(ScreenResizeEvent(w, h))
end
