local SceneManager = require("renderer.scenemanager")

local function create_mock_scene()
    return {
        enter_calls = 0,
        exit_calls = 0,
        update_calls = 0,
        draw_calls = 0,
        enter = function(self) self.enter_calls = self.enter_calls + 1 end,
        exit = function(self) self.exit_calls = self.exit_calls + 1 end,
        update = function(self, dt) self.update_calls = self.update_calls + 1 end,
        draw = function(self) self.draw_calls = self.draw_calls + 1 end,
    }
end

describe("SceneManager", function()
    local sm
    local scene_a, scene_b

    before_each(function()
        scene_a = create_mock_scene()
        scene_b = create_mock_scene()
    end)

    describe("new", function()
        it("creates a SceneManager with empty scenes table", function()
            sm = SceneManager:new({})
            assert.are.same({}, sm.scenes)
            assert.is_nil(sm.active)
        end)

        it("adds all scenes passed to constructor", function()
            sm = SceneManager:new({
                menu = scene_a,
                game = scene_b,
            })
            assert.are.equal(scene_a, sm.scenes.menu)
            assert.are.equal(scene_b, sm.scenes.game)
        end)
    end)

    describe("add", function()
        it("adds a scene by name", function()
            sm = SceneManager:new({})
            sm:add("menu", scene_a)
            assert.are.equal(scene_a, sm.scenes.menu)
        end)

        it("replaces existing scene with same name", function()
            sm = SceneManager:new({ menu = scene_a })
            sm:add("menu", scene_b)
            assert.are.equal(scene_b, sm.scenes.menu)
        end)

        it("sets scene_manager reference", function()
            sm = SceneManager:new({})
            sm:add("menu", scene_a)
            assert.are.equal(sm, scene_a.scene_manager)
        end)
    end)

    describe("transition", function()
        before_each(function()
            sm = SceneManager:new({ menu = scene_a, game = scene_b })
        end)

        it("sets active scene", function()
            sm:transition("menu")
            assert.are.equal(scene_a, sm.active)
        end)

        it("calls enter on new scene", function()
            sm:transition("menu")
            assert.are.equal(1, scene_a.enter_calls)
        end)

        it("calls exit on previous scene when transitioning", function()
            sm:transition("menu")
            sm:transition("game")
            assert.are.equal(1, scene_a.exit_calls)
            assert.are.equal(1, scene_b.enter_calls)
        end)

        it("does not call exit when no previous scene", function()
            sm:transition("menu")
            assert.are.equal(0, scene_a.exit_calls)
        end)

        it("throws error for non-existent scene", function()
            assert.has_error(function()
                sm:transition("nonexistent")
            end)
        end)
    end)

    describe("callback forwarding", function()
        before_each(function()
            sm = SceneManager:new({ game = scene_a })
            sm:transition("game")
        end)

        it("forwards update to active scene", function()
            sm:update(0.016)
            assert.are.equal(1, scene_a.update_calls)
        end)

        it("forwards draw to active scene", function()
            sm:draw()
            assert.are.equal(1, scene_a.draw_calls)
        end)

        it("does not call if scene lacks method", function()
            local scene_no_update = create_mock_scene()
            scene_no_update.update = nil
            sm:add("minimal", scene_no_update)
            sm:transition("minimal")
            assert.has_no_error(function()
                sm:update(0.016)
            end)
        end)

        it("throws error when no active scene", function()
            sm.active = nil
            assert.has_error(function()
                sm:update(0.016)
            end)
        end)
    end)
end)
