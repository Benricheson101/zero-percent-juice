local UITextbox = require('ui.textbox')

describe('UITextbox', function()
    describe('new', function()
        it('creates textbox with default values', function()
            local textbox = UITextbox:new {}

            assert.are.equal(0, textbox.x)
            assert.are.equal(0, textbox.y)
            assert.are.equal(0, textbox.width)
            assert.are.equal(0, textbox.height)
            assert.are.equal('', textbox.value)
            assert.are.equal('', textbox.placeholder)
            assert.is_nil(textbox.focused)
            assert.are.equal(0.5, textbox.blinkRate)
            assert.is_true(textbox.caretVisible)
        end)

        it('creates textbox with custom values', function()
            local textbox = UITextbox:new {
                x = 100,
                y = 200,
                width = 300,
                height = 50,
                value = 'test value',
                focused = true,
                placeholder = 'Enter name',
                maxLength = 32,
                blinkRate = 1,
            }

            assert.are.equal(100, textbox.x)
            assert.are.equal(200, textbox.y)
            assert.are.equal(300, textbox.width)
            assert.are.equal(50, textbox.height)
            assert.are.equal('test value', textbox.value)
            assert.is_true(textbox.focused)
            assert.are.equal('Enter name', textbox.placeholder)
            assert.are.equal(32, textbox.maxLength)
            assert.are.equal(1, textbox.blinkRate)
        end)

        it('sets default blinkRate', function()
            local textbox = UITextbox:new {}
            assert.are.equal(0.5, textbox.blinkRate)
        end)

        it('sets default blinkRate when provided', function()
            local textbox = UITextbox:new { blinkRate = 2 }
            assert.are.equal(2, textbox.blinkRate)
        end)

        it('sets default maxLength to 0', function()
            local textbox = UITextbox:new {}
            assert.are.equal(0, textbox.maxLength)
        end)

        it('sets onInput to empty function by default', function()
            local textbox = UITextbox:new {}
            assert.is_function(textbox.onInput)
        end)
    end)

    describe('update', function()
        it('hides caret when not focused', function()
            local textbox = UITextbox:new { focused = false }
            textbox.caretVisible = true
            textbox:update(0.016)
            assert.is_false(textbox.caretVisible)
        end)

        it('does not update blink when blinkRate is 0', function()
            local textbox = UITextbox:new { focused = true, blinkRate = 0 }
            textbox.caretVisible = true
            textbox:update(1)
            assert.is_true(textbox.caretVisible)
        end)

        it('toggles caret visibility on blink cycle', function()
            local textbox = UITextbox:new { focused = true, blinkRate = 0.5 }
            textbox.caretVisible = true
            textbox.blinkTime = 0
            textbox:update(0.5)
            assert.is_false(textbox.caretVisible)
            assert.are.equal(0, textbox.blinkTime)
        end)

        it('resets blinkTime after toggle', function()
            local textbox = UITextbox:new { focused = true, blinkRate = 0.5 }
            textbox.caretVisible = true
            textbox.blinkTime = 0.25
            textbox:update(0.5)
            assert.are.equal(0, textbox.blinkTime)
        end)

        it('does not toggle if blinkTime is less than blinkRate', function()
            local textbox = UITextbox:new { focused = true, blinkRate = 0.5 }
            textbox.caretVisible = true
            textbox.blinkTime = 0.3
            textbox:update(0.1)
            assert.is_true(textbox.caretVisible)
        end)
    end)

    describe('keypressed', function()
        it('does nothing when not focused', function()
            local textbox = UITextbox:new { focused = false }
            textbox.value = 'test'
            textbox:keypressed('backspace')
            assert.are.equal('test', textbox.value)
        end)

        it('removes last character on backspace', function()
            local textbox = UITextbox:new { focused = true }
            textbox.value = 'test'
            textbox:keypressed('backspace')
            assert.are.equal('tes', textbox.value)
        end)

        it('calls onSubmit with value on return', function()
            local submittedValue = nil
            local textbox = UITextbox:new {
                focused = true,
                value = 'player1',
                onSubmit = function(self, value)
                    submittedValue = value
                end,
            }
            textbox:keypressed('return')
            assert.are.equal('player1', submittedValue)
        end)

        it('does not submit empty value', function()
            local submitted = false
            local textbox = UITextbox:new {
                focused = true,
                value = '',
                onSubmit = function(self, value)
                    submitted = true
                end,
            }
            textbox:keypressed('return')
            assert.is_false(submitted)
        end)

        it('ignores other keys', function()
            local textbox = UITextbox:new { focused = true }
            textbox.value = 'test'
            textbox:keypressed('a')
            assert.are.equal('test', textbox.value)
        end)
    end)

    describe('textinput', function()
        it('does nothing when not focused', function()
            local textbox = UITextbox:new { focused = false }
            textbox.value = 'test'
            textbox:textinput('a')
            assert.are.equal('test', textbox.value)
        end)

        it('appends text when focused', function()
            local textbox = UITextbox:new { focused = true }
            textbox:textinput('a')
            assert.are.equal('a', textbox.value)
        end)

        it('respects maxLength limit', function()
            local textbox = UITextbox:new { focused = true, maxLength = 3 }
            textbox.value = 'ab'
            textbox:textinput('c')
            assert.are.equal('abc', textbox.value)
            textbox:textinput('d')
            assert.are.equal('abcd', textbox.value)
        end)

        it('does not append when at maxLength', function()
            local textbox = UITextbox:new { focused = true, maxLength = 3 }
            textbox.value = 'abc'
            textbox:textinput('d')
            assert.are.equal('abcd', textbox.value)
        end)

        it('calls onInput after adding text', function()
            local inputValue = nil
            local textbox = UITextbox:new {
                focused = true,
                onInput = function(self, value)
                    inputValue = value
                end,
            }
            textbox:textinput('a')
            assert.are.equal('a', inputValue)
        end)

        it('allows unlimited input when maxLength is 0', function()
            local textbox = UITextbox:new { focused = true, maxLength = 0 }
            local longString = string.rep('a', 100)
            textbox:textinput(longString)
            assert.are.equal(100, #textbox.value)
        end)
    end)
end)
