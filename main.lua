function love.load()
  math.randomseed(os.time())

  json = require('plugins.json')
  tiny = require('plugins.tiny-ecs')
  class = require('plugins.middleclass')
  ldtk = require('plugins.super-simple-ldtk')

  GAME_WIDTH = 200
  GAME_HEIGHT = 200
  GAME_SCALE = 4
  GRAVITY = 25
  MAX_GRAVITY = 800
  JUMP_HEIGHT = 400
  NEW_LINE = string.char(10)

  SYSTEMS_IN_ORDER = {
    require('systems.audio-system'),
    require('systems.accident-system'),
    require('systems.collision-registration-system'),
    require('systems.keyboard-state-system'),
    require('systems.tile-map-system'),
    require('systems.vehicle-input-system'),
    require('systems.truck-package-system'),
    require('systems.character-interaction-system'),
    require('systems.character-input-system'),
    require('systems.sprite-animating-system'),
    require('systems.entity-movement-system'),
    require('systems.collision-detection-system'),
    require('systems.delivery-detection-system'),
    require('systems.delivery-indicator-system'),
    require('systems.box-delivery-linking-system'),
    require('systems.repel-system'),
    require('systems.friction-system'),
    require('systems.revolve-around-system'),
    require('systems.camera-system'),
    --drawing
    require('systems.background-sprite-drawing-system'),
    require('systems.lower-sprite-drawing-system'),
    require('systems.middle-sprite-drawing-system'),
    require('systems.upper-sprite-drawing-system'),
    require('systems.foreground-sprite-drawing-system'),
    require('systems.game-state-system'),
    require('systems.dialogue-system'),
    -- cleanup
    require('systems.debug-overlay-system'),
    require('systems.entity-cleanup-system'),
    require('systems.time-to-live-system'),
    require('systems.delayed-function-execution-system'),
  }

  PALETTE = {
    BACKGROUND = { love.math.colorFromBytes(48, 44, 46) }, --#302c2e
  }

  local windowWidth, windowHeight = love.window.getDesktopDimensions()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  logger = require('logger')()

  KeyPressEvent = require('entities.events.key-press')
  KeyReleaseEvent = require('entities.events.key-release')
  ScreenResizeEvent = require('entities.events.screen-resize')

  local joystick_state = require('shared-access.joystick')() --[[@as JoystickState]]
  local keyboard_state = require('shared-access.keyboard')() --[[@as KeyboardState]]
  local entity_factory = require('shared-access.entity-factory')() --[[@as EntityFactory]]
  local collision_grid = require('shared-access.collision-grid')(16, 1000, 1000) --[[@as CollisionGrid]]
  local game_state = require('shared-access.game-state')() --[[@as GameState]]
  local camera_state = require('shared-access.camera-state')() --[[@as CameraState]]

  love.graphics.setLineStyle('rough')
  love.window.setMode(GAME_WIDTH * GAME_SCALE, GAME_HEIGHT * GAME_SCALE)
  tiny_world = tiny.world()

  for _, system in ipairs(SYSTEMS_IN_ORDER) do
    if system.initialize then
      system:initialize({
        joystick_state = joystick_state,
        keyboard_state = keyboard_state,
        entity_factory = entity_factory,
        collision_grid = collision_grid,
        game_state = game_state,
        camera_state = camera_state,
      })
    end
    tiny_world:addSystem(system)
  end
  tiny_world:addEntity({
    is_event = true,
    load_tile_map = true,
  })
  local first_message = {
    is_dialogue = true,
    messages = {
      'Dispatch: Alright, listen up' .. NEW_LINE .. 'newbie, this is how its' .. NEW_LINE .. 'gonna be',
      'Dispatch: You need to deliver' .. NEW_LINE .. 'these packages.',
      'Dispatch: The more you deliver,' .. NEW_LINE .. 'the more money you get.' .. NEW_LINE .. 'Simple.',
      'Dispatch: The truck loaders have' .. NEW_LINE .. 'the day off, you gotta' .. NEW_LINE .. 'load the truck',
      'Dispatch: Pick up boxes and put' .. NEW_LINE .. 'them in the back.',
    },
  }
  local second_message = {
    is_dialogue = true,
    messages = {
      'Dispatch: The truck can fit' .. NEW_LINE .. 'five boxes',
      'Dispatch: Then you get in' .. NEW_LINE .. 'the truck and drive' .. NEW_LINE .. 'to the Next Delivery',
    },
  }
  local third_message = {
    is_dialogue = true,
    messages = {
      'Dispatch: And one more thing...',
      'Dispatch: If we make it 5 days' .. NEW_LINE .. 'without an accident' .. NEW_LINE .. 'we get a pizza party.',
      "Dispatch: We're currently at 4...",
      "Dispatch: Don't mess it up.",
      'Dispatch: What are you waiting' .. NEW_LINE .. 'for? Get moving.',
    },
  }
  second_message.on_complete = function()
    tiny_world:addEntity(third_message)
  end
  first_message.on_complete = function()
    tiny_world:addEntity(second_message)
  end
  tiny_world:addEntity(first_message)
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
