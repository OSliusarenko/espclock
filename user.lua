-- setup SPI and connect display
function init_spi_display()
    -- Hardware SPI CLK  = GPIO14 D5
    -- Hardware SPI MOSI = GPIO13 D7
    -- Hardware SPI MISO = GPIO12 D6 (not used)
    -- CS, D/C, and RES can be assigned freely to available GPIOs
    local cs  = 1 -- 
    local dc  = 2 -- 
    local res = 0 -- 

    spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 800, spi.FULLDUPLEX)
    disp = u8g.pcd8544_84x48_hw_spi(cs, dc, res)
end

function read_time()
    local ds3231=require("ds3231")
    ds3231.init(3, 4) -- sda, scl
    local second, minute, hour, day, date, month, year = ds3231.getTime();
    local tm=string.format("%s:%s:%s", hour, minute, second)
    local dt=string.format("%s/%s/%s", date, month, year)
    ds3231 = nil
    package.loaded["ds3231"]=nil
    return tm, dt
end

-- print on display
init_spi_display()
disp:setFont(u8g.font_chikita)

function print_LCD()
    local tm, dt = read_time()
    disp:firstPage()
    repeat
        disp:drawStr(0, 10, tm)
        disp:drawStr(0, 17, dt)
    until disp:nextPage() == false
end

function run()
    tmr.alarm(0, 60*1000, tmr.ALARM_AUTO, function() 
        print_LCD()
    end
    )
end
    
print_LCD()
--go()

