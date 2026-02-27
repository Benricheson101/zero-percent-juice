# Testing Guidelines

## Running tests
We're using a test suite called [`busted`](https://lunarmodules.github.io/busted/). Tests can be run by using:
```sh
$ busted ./spec
```

## How to structure code
To maximize testability, we want to keep Love2D-related code separate from core game logic. This may feel a bit awkward, but the testing library has no way of running functions that call Love2D. Additionally, try to use the Love2D callback functions instead of `love` methods when possible. For example:

```lua
-- instead of
function Player:update(key)
    if love.keyboard.isDown("up") then
        self.posY += 1
    end
end

-- use something like
function Player:keypressed(key)
    if key == 'up' then
        self.posY += 1
    elseif key == 'down' then
        self.posY -= 1
    end
end

function GameScene:keypressed(key)
    self.player:keypressed(key)
end
```

Notice how no `love` APIs are used. This means the Player behavior can be tested without relying on the `love` APIs.

## Writing tests
Test files reside in `./spec`. Tests can either be written as unit tests or behavior tests, depending on what you are testing. Unit tests are best for testing individual functions, and there should be one or more tests for each function. Behavior tests more closely mirror human interaction, and should read like a sentence "Scenario: \<what is being tested>. Given \<state>, when \<action>, then/it |<expected-result>". Unit tests should be used for testing individual functions, whereas behavior tests test the actual behavior of the game, which may encompass many elements.

Tests ultimately call assertion functions. Busted uses [luassert](https://github.com/lunarmodules/luassert) for this.

Example unit test:
```lua
describe("SceneManager", function()
    describe("add", function()
        it("adds a scene by name", function()
            -- ...
            assert.are.equal(sm.scenes.my_scene, my_scene)
        end)
    end)
end)
```

Example behavior test:
```lua
describe("Player Movement", function()
    describe("Given the 'game' scene is active", function()
        describe("When the up arrow is pressed", function()
            it("moves the player up along the Y-axis", function()
                -- ...
            end)

            it("plays move up animation", function()
                -- ...
            end)
        end)


        describe("When the down arrow is pressed", function()
            it("moves the player down along the Y-axis", function()
                -- ...
            end)

            it("plays move down animation", function()
                -- ...
            end)
        end)
    end)
end)
```
